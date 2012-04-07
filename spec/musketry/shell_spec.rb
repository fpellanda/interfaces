require "spec_helper.rb"

module Musketry
  describe Shell do

    let(:context) {
      Context.new.tap {|context|
        context.use(Musketry::Shell)
      }
    }    

    it "should return a new instance" do
      c = Shell.instance_from_definition("shell myname")
      c.should_not be_nil
      c.name.should == "myname"
    end

    describe "parsing" do
      it "should add a shell function that is registered" do
        context[:reset].should be_nil
        context.parse(<<EOF)
shell reset
  echo "hello"
EOF
        context[:reset].should_not be_nil
      end

      it "should add shell function but no subsubcontext" do
        context.parse(<<EOF)
shell reset
  echo 'hello'
    echo really subcontext?
EOF
        context[:reset].should_not be_nil
        context[:reset].contexts.should == ["echo 'hello'\n","  echo really subcontext?\n"]
      end
    end

    describe "call" do
      it "should call function and return stdout+stderr" do
        context.parse(<<EOF)
shell print
  echo something
  echo error >&2
EOF
        result = context[:print].call
        result.should_not be_nil
        result.should == "something\nerror\n"
      end

      it "should call function with a stdinput" do
        context.parse(<<EOF)
shell print
  echo here comes the input
  cat | tr "x" "X"
EOF
        result = context[:print].call("stdin text")
        result.should_not be_nil
        result.should == "here comes the input\nstdin teXt"
      end
    end
  end
end
