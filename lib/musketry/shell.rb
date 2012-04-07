class Musketry::Shell < Musketry::Context
  
  def self.instance_from_definition(line)
    return unless line =~ /^(sh|shell) (\S+)$/
    self.new.tap {|inst|
      inst.name = $2
    }
  end

  def initialize
    super
  end

  def call(stdin = nil)
    out_str, status = Open3.capture2e("sh","-c",contexts.join, :stdin_data=>stdin)
    out_str
  end

end
