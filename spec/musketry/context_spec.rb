require "spec_helper.rb"

module Musketry
  describe Context do
    
    describe "parsing" do

      it "should have subcontexts by default" do
        c = Context.new
        c.context_classes.should == [Context]
      end

      it "should return a new instance with the definition as name" do
        c = Context.instance_from_definition("Myname")
        c.should_not be_nil
        c.name.should == "Myname"
      end

      it "should parse emtpy file" do
        result = Context.parse("")
        result.should_not be_nil
        result.name.should be_nil
        result.contexts.should == []
      end
      
      it "should just return a context for each line" do
        result = Context.parse(<<EOF)
line1
line2
EOF

        result.name.should be_nil
        result.contexts.should == ["line1\n","line2\n"]
        # access contexts with []
        result[0].should == "line1\n"
        result[1].should == "line2\n"
      end

      it "should parse subcontexts" do
        result = Musketry::Context.parse(<<EOF)
line1
subcontext
  subline1
  subline2
  subsubcontext
    subsubline
line2
EOF

        result.contexts.count.should == 3
        result[0].should == "line1\n"
        result[1].class.should == Context
        result[1].name.should == "subcontext\n"
        result[1].contexts.length.should == 3
        result[1].contexts[0..1].should == ["subline1\n","subline2\n"]
        result[1][-1].class.should == Context
        result[1][-1].name.should == "subsubcontext\n"
        result[1][-1].contexts.should == ["subsubline\n"]
        result[2].should == "line2\n"
      end
      
      it "should return a subcontext with no name" do
        result = Musketry::Context.parse("  line")
        result.contexts.count.should == 1
        result.contexts[0].name.should be_nil
        result.contexts[0].contexts.should == ["line"]
      end

    end
  end
end

