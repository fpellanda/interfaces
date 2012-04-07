class Musketry::Context
  
  def self.normalize_io(io)
    case io
    when String
      StringIO.new(io)
    else
      io
    end
  end

  def self.parse(io)
    self.new.tap {|context|
      context.parse(io)
    }
  end

  def self.instance_from_definition(line)
    return nil unless self.name == "Musketry::Context"
    self.new.tap {|inst|
      inst.name = line
    }
  end

  attr_accessor :name, :contexts, :context_classes, :contexts_hash

  def initialize
    super
    @context_classes = [self.class]
    @contexts_hash = {}
    @contexts = []
  end

  def [](key)
    case key
    when Fixnum
      contexts[key]
    when Symbol
      contexts_hash[key]
    else
      raise "Unexpected key class #{key.class}"
    end
  end

  def use(context_class)
    @context_classes.insert(0,context_class)
  end

  def instance_from_definition(definition)
    context_classes.each {|cc|
      inst = cc.instance_from_definition(definition)
      return inst if inst
    }
    nil
  end

  def parse(io)
    io = self.class.normalize_io(io)
    @contexts = []
    while io.gets do
      # this may happen on a redo
      break if $_.nil?

      raise "Unexpected line #{$_.inspect}" unless $_ =~ /^(  )?(.*)$/
      indent = $1

      if indent and
          subcontext = instance_from_definition(@contexts[-1])
          
        @contexts.pop
        content = $_.sub(indent, "")
        while io.gets and $_.starts_with?(indent)
          content += $_.sub(indent, "")
        end
        subcontext.parse(StringIO.new(content))
        @contexts << subcontext
        if name = subcontext.name
          @contexts_hash[name.to_sym] = subcontext
        end
        redo
      end
        
      @contexts << $_
    end
  end
  
end
