# generated by mmeta on Mon May 23 17:32:45 PDT 2011
# do not modify, instead edit original .mmeta file
package mmeta
import java.util.ArrayList
import java.util.Date
import java.util.List
import java.util.EnumSet
import mmeta.*


import java.util.*

import java.io.File

import hapax.TemplateCache

import hapax.TemplateDataDictionary

import hapax.TemplateDictionary

import hapax.TemplateResourceLoader




class MMetaCompiler < BaseParser
  def _init
    @error = RuleFailure.new
    @chars = _chars
    super()
  end

  def _error(expected:String)
    #throws RuleFailure
    @error.last = expected unless ''.equals(expected)
    raise @error
  end


  def self.main(args:String[]): void
          if args.length < 1
              puts "MMetaCompiler <input> [output]"
              System.exit(2)
          end
          # if args.length > 1 && args[1].equals("--embed")
          #     embed = true
          # end
          options = {recursion: Boolean.valueOf(false), auto_memo: Boolean.valueOf(false), debug: Boolean.valueOf(false)}
          templates = { }
          i = 0
          while i < args.length && args[i].startsWith('--')
            arg = args[i].substring(2)
            if options.containsKey(arg)
              options.put(arg, Boolean.valueOf(true))
            elsif "tpl".equals(arg)
              i += 1
              arg = args[i]
              pieces = arg.split('=')
              templates[pieces[0]] = File.new(pieces[1]).getAbsolutePath
            else
              puts "Unrecognized option --#{arg}."
              puts "Supported options: #{options.keySet}"
              System.exit(1)
            end
            i += 1
          end
          if args.length > i
            output_file = args[i + 1]
          else
            output_file = args[i] + ".mirah"
          end
          input = Utils.readFile(args[i])
    
          compiler = MMetaCompiler.new
          compiler.left_recursion = Boolean(options.get(:recursion)).booleanValue
          compiler.auto_memo = Boolean(options.get(:auto_memo)).booleanValue
          compiler.debug = Boolean(options.get(:debug)).booleanValue
          compiler.template_paths.putAll(templates)
          # compiler.embedded = embed
          parser = MMetaParser.new
          BaseParser.tracing = false
          ast = parser.parse(input)
          BaseParser.tracing = false
          # puts BaseParser.print_r(ast)
    
          output = String(compiler.parse(ast))
          Utils.writeFile(output_file, output)
          System.exit(0)
        
  end
  

  def initialize()
    
          @jpackage = String(nil)
          @embedded = false
          @locals = ArrayList.new
          @methods = ArrayList.new
          @rules = ArrayList.new
          @ranges = HashMap.new
          @sname = "ERROR-sname-ERROR"
          @name = "ERROR-name-ERROR"
          @_ = "  "
          @__genc = -1
          @left_recursion = Boolean.getBoolean("mmeta.left_recursion")
          @auto_memo = Boolean.getBoolean("mmeta.auto_memo")
          @templates = TemplateResourceLoader.create('mmeta/templates/')
          @custom_templates = TemplateCache.create('/')
          @user_template_paths = {}
          @debug = Boolean.getBoolean("mmeta.debug")
        
  end
  

  def template_paths()
     @user_template_paths 
  end
  

  def left_recursion_set(value:boolean)
    
          @left_recursion = value
        
  end
  

  def auto_memo_set(value:boolean)
    
          @auto_memo = value
        
  end
  

  def debug_set(value:boolean)
    
          @debug = value
        
  end
  

  def reset()
    
            @locals = ArrayList.new
            @methods = ArrayList.new
            @rules = ArrayList.new
        
  end
  

  def addLocal(n:Object)
    
            s = String(n).intern
            @locals.add(s) unless @locals.contains(s)
        
  end
  

  def localsAsInit()
    
          @locals.each do |local|
            @dict.addSection(:LOCALS).setVariable(:LOCAL, local.toString)
          end
          @locals.clear
        
  end
  

  def embedded_set(embedded:boolean)
    @embeded = embedded
  end
  

  def genvar()
     "" + (@__genc = @__genc + 1); 
  end
  

  
  def destruct
    #throws RuleFailure
    begin
      _start = _pos; t = nil; r = nil
      begin
        begin
          _p0 = _pos
          begin
            t = (
              self._any()
            )
            r = (
              self.apply(t)
            )
            self.end()
            r
          rescue RuleFailure => ex
            self._pos = _p0
            raise ex
          end
        end
      rescue RuleFailure
        raise SyntaxError.new("", @error.last, _pos, _string, _list)
      end
    rescue RuleFailure => ex
      ex.last = 'destruct'
      raise ex
    end
  end
  

  
  def trans
    #throws RuleFailure
    __saved_dict = @dict
    begin
      _start = _pos; r = nil
      begin
        _p1 = _pos
        begin
          begin
            _t = _listBegin()
            begin
              r = (
                self.destruct()
              )
            ensure
              _listEnd()
            end
          end
          r
        rescue RuleFailure => ex
          self._pos = _p1
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'trans'
      raise ex
    ensure
      @dict = __saved_dict
    end
  end
  

  
  def HList
    #throws RuleFailure
    begin
      _start = _pos; ls = nil
      begin
        _p3 = _pos
        begin
          ls = (
            begin
              as2 = ArrayList.new
              begin
                while true do
                  _li = Object(
                    self.trans()
                  )
                  as2.add(_li)
                end
              rescue RuleFailure; end
              as2
            end
          )
          begin
            
                  if List(ls).size == 0
                    "ArrayList.new"
                  else
                    "[#{join(ls, ", ")}]"
                  end
                
          end
        rescue RuleFailure => ex
          self._pos = _p3
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'HList'
      raise ex
    end
  end
  

  
  def HConcat
    #throws RuleFailure
    begin
      _start = _pos; l = nil; r = nil
      begin
        _p4 = _pos
        begin
          l = (
            self.trans()
          )
          r = (
            self.trans()
          )
          "concat(#{l}, #{r})"
        rescue RuleFailure => ex
          self._pos = _p4
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'HConcat'
      raise ex
    end
  end
  

  
  def HStr
    #throws RuleFailure
    begin
      _start = _pos; c = nil
      begin
        _p5 = _pos
        begin
          c = (
            self._any()
          )
          "\"#{c}\""
        rescue RuleFailure => ex
          self._pos = _p5
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'HStr'
      raise ex
    end
  end
  

  
  def HLit
    #throws RuleFailure
    begin
      _start = _pos; c = nil
      begin
        _p6 = _pos
        begin
          c = (
            self._any()
          )
          c
        rescue RuleFailure => ex
          self._pos = _p6
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'HLit'
      raise ex
    end
  end
  

  
  def Node
    #throws RuleFailure
    begin
      _start = _pos; n = nil; ls = nil
      begin
        _p9 = _pos
        begin
          n = (
            self._any()
          )
          begin
            _t = _listBegin()
            begin
              begin
                _p8 = _pos
                begin
                  _sym("HList")
                  ls = (
                    begin
                      as7 = ArrayList.new
                      begin
                        while true do
                          _li = Object(
                            self.trans()
                          )
                          as7.add(_li)
                        end
                      rescue RuleFailure; end
                      as7
                    end
                  )
                rescue RuleFailure => ex
                  self._pos = _p8
                  raise ex
                end
              end
            ensure
              _listEnd()
            end
          end
          begin
            
                  add_dict
                  @dict.setVariable(:TYPE, n.toString)
                  if ls.isEmpty
                    @dict.showSection(:NO_CHILDREN)
                  else
                    @dict.showSection(:CHILDREN)
                  end
                  ls.each do |x|
                    @dict.addSection(:CHILD).setVariable(:CHILD, x.toString)
                  end
                  render(:node)
                
          end
        rescue RuleFailure => ex
          self._pos = _p9
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Node'
      raise ex
    end
  end
  

  
  def Error
    #throws RuleFailure
    begin
      _start = _pos; msg = nil; body = nil
      begin
        _p10 = _pos
        begin
          msg = (
            self._any()
          )
          body = (
            self.trans()
          )
          begin
            
                  add_dict
                  @dict.setVariable(:MESSAGE, msg.toString)
                  add_expr(:BODY, body)
                  render(:syntax_error)
                
          end
        rescue RuleFailure => ex
          self._pos = _p10
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Error'
      raise ex
    end
  end
  

  
  def Set
    #throws RuleFailure
    begin
      _start = _pos; n = nil; x = nil
      begin
        _p11 = _pos
        begin
          n = (
            self._any()
          )
          x = (
            self.trans()
          )
          begin
            
                    addLocal(n);
                    add_dict
                    @dict.setVariable(:NAME, n.toString)
                    add_expr(:EXPR, x)
                    render(:save_to_var)
                
          end
        rescue RuleFailure => ex
          self._pos = _p11
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Set'
      raise ex
    end
  end
  

  
  def Str
    #throws RuleFailure
    begin
      _start = _pos; s = nil
      begin
        _p12 = _pos
        begin
          s = (
            self._any()
          )
          begin
             compile_literal_string(s) 
          end
        rescue RuleFailure => ex
          self._pos = _p12
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Str'
      raise ex
    end
  end
  

  
  def Sym
    #throws RuleFailure
    begin
      _start = _pos; s = nil
      begin
        _p13 = _pos
        begin
          s = (
            self._any()
          )
          "_sym(\"#{s}\")"
        rescue RuleFailure => ex
          self._pos = _p13
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Sym'
      raise ex
    end
  end
  

  
  def App
    #throws RuleFailure
    begin
      _start = _pos; rule = nil; args = nil
      begin
        begin
          _p15 = _pos
          begin
            _sym("super")
            rule = (
              self._any()
            )
            args = (
              begin
                as14 = ArrayList.new
                begin
                  while true do
                    _li = Object(
                      self.trans()
                    )
                    as14.add(_li)
                  end
                rescue RuleFailure; end
                as14
              end
            )
            begin
              
                       "super(#{join(args, ", ")})"
                       
            end
          rescue RuleFailure => ex
            self._pos = _p15
            raise ex
          end
        end
      rescue RuleFailure
        begin
          _p17 = _pos
          begin
            rule = (
              self._any()
            )
            args = (
              begin
                as16 = ArrayList.new
                begin
                  while true do
                    _li = Object(
                      self.trans()
                    )
                    as16.add(_li)
                  end
                rescue RuleFailure; end
                as16
              end
            )
            begin
              
                       "self.#{rule}(#{join(args, ", ")})"
                       
            end
          rescue RuleFailure => ex
            self._pos = _p17
            raise ex
          end
        end
      end
    rescue RuleFailure => ex
      ex.last = 'App'
      raise ex
    end
  end
  

  
  def Dot
    #throws RuleFailure
    begin
      _start = _pos
      "ws()"
    rescue RuleFailure => ex
      ex.last = 'Dot'
      raise ex
    end
  end
  

  
  def SAct
    #throws RuleFailure
    begin
      _start = _pos; expr = nil
      begin
        _p18 = _pos
        begin
          expr = (
            self.trans()
          )
          "#{expr}"
        rescue RuleFailure => ex
          self._pos = _p18
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'SAct'
      raise ex
    end
  end
  

  
  def Act
    #throws RuleFailure
    begin
      _start = _pos; expr = nil
      begin
        _p19 = _pos
        begin
          expr = (
            self._any()
          )
          begin
            
                    add_dict
                    add_expr(:BODY, expr)
                    render(:action)
                
          end
        rescue RuleFailure => ex
          self._pos = _p19
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Act'
      raise ex
    end
  end
  

  
  def Pred
    #throws RuleFailure
    begin
      _start = _pos; expr = nil
      begin
        _p20 = _pos
        begin
          expr = (
            self._any()
          )
          begin
            
                  add_dict
                  unless expr.nil? || "false".equals(expr.toString.trim)
                    @dict.setVariable(:EXPR, expr.toString)
                  end
                  render('predicate')
                
          end
        rescue RuleFailure => ex
          self._pos = _p20
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Pred'
      raise ex
    end
  end
  

  
  def SynPred
    #throws RuleFailure
    begin
      _start = _pos; pred = nil; body = nil; tail = nil
      begin
        begin
          _p22 = _pos
          begin
            pred = (
              self.trans()
            )
            body = (
              self.trans()
            )
            tail = (
              begin
                self.trans()
              rescue RuleFailure
                begin
                  _p21 = _pos
                  begin
                    self.end()
                    nil
                  rescue RuleFailure => ex
                    self._pos = _p21
                    raise ex
                  end
                end
              end
            )
            begin
              
                    add_dict
                    add_expr(:PRED, pred)
                    add_expr(:BODY, body)
                    unless tail.nil?
                      add_expr(:ELSE, tail, @dict.addSection(:ELSE))
                    end
                    render('syn_pred')
                  
            end
          rescue RuleFailure => ex
            self._pos = _p22
            raise ex
          end
        end
      rescue RuleFailure
        raise SyntaxError.new("", @error.last, _pos, _string, _list)
      end
    rescue RuleFailure => ex
      ex.last = 'SynPred'
      raise ex
    end
  end
  

  
  def Token
    #throws RuleFailure
    begin
      _start = _pos; name = nil
      begin
        _p23 = _pos
        begin
          name = (
            self._any()
          )
          "_lex(Tokens.t#{name})"
        rescue RuleFailure => ex
          self._pos = _p23
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Token'
      raise ex
    end
  end
  

  
  def TokenRange
    #throws RuleFailure
    begin
      _start = _pos; first = nil; last = nil
      begin
        _p24 = _pos
        begin
          first = (
            self._any()
          )
          last = (
            self._any()
          )
          begin
            
                  range = lookup_range(first, last)
                  add_dict
                  @dict.setVariable(:FIRST, first.toString)
                  @dict.setVariable(:LAST, last.toString)
                  @dict.setVariable(:RANGE, range)
                  render('token_range')
                
          end
        rescue RuleFailure => ex
          self._pos = _p24
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'TokenRange'
      raise ex
    end
  end
  

  
  def TLit
    #throws RuleFailure
    begin
      _start = _pos; name = nil
      begin
        _p25 = _pos
        begin
          name = (
            self._any()
          )
          begin
            
                  token = Integer.valueOf(lookup_token(name))
                  add_dict
                  @dict.setVariable(:NAME, name.toString)
                  @dict.setVariable(:TOKEN, token.toString)
                
          end
        rescue RuleFailure => ex
          self._pos = _p25
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'TLit'
      raise ex
    end
  end
  

  
  def Or
    #throws RuleFailure
    begin
      _start = _pos; xs = nil
      begin
        _p27 = _pos
        begin
          xs = (
            begin
              as26 = ArrayList.new
              begin
                while true do
                  _li = Object(
                    self.trans()
                  )
                  as26.add(_li)
                end
              rescue RuleFailure; end
              as26
            end
          )
          begin
            
                  dict = add_dict
                  dict.setVariable(:ELSE, 'or')
                  exprs = List(xs)
                  if exprs.size == 0
                    ""
                  elsif exprs.size == 1
                    @dict.setVariable(:EXPR, exprs.get(0).toString)
                    render(:simple_expr)
                  else
                    0.upto(exprs.size - 2) do |i|
                      expr = exprs.get(i)
                      add_expr(:EXPR, expr)
                      @dict = @dict.addSection(:ELSE) unless i == (exprs.size - 2)
                    end
                    add_expr(:ELSE, exprs.get(exprs.size - 1))
                    render('or', dict)
                  end
                
          end
        rescue RuleFailure => ex
          self._pos = _p27
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Or'
      raise ex
    end
  end
  

  
  def And
    #throws RuleFailure
    begin
      _start = _pos; ts = nil
      begin
        begin
          _p29 = _pos
          begin
            ts = (
              begin
                as28 = ArrayList.new
                begin
                  while true do
                    _li = Object(
                      self.trans()
                    )
                    as28.add(_li)
                  end
                rescue RuleFailure; end
                raise @error if as28.size == 0
                as28
              end
            )
            begin
              
                         add_dict
                         @dict.setVariable(:VAR, genvar)
                         err = String(nil)
                         List(ts).each do |expr|
                           add_expr(:EXPR, expr, @dict.addSection(:EXPR))
                         end
                         render('and')
                       
            end
          rescue RuleFailure => ex
            self._pos = _p29
            raise ex
          end
        end
      rescue RuleFailure
        ""
      end
    rescue RuleFailure => ex
      ex.last = 'And'
      raise ex
    end
  end
  

  def makeMany(x:Object, many1:boolean)
    
          add_dict
          @dict.setVariable(:VAR, genvar)
          @dict.setVariable(:LIST_ITEMS, :list_items)
          add_expr(:EXPR, x)
          add_expr(:EXPR, x, @dict.addSection(:LIST_ITEMS))
          if many1
            render('build_non_empty_list')
          else
            render('build_list')
          end
        
  end
  

  
  def Many
    #throws RuleFailure
    begin
      _start = _pos; x = nil
      begin
        _p30 = _pos
        begin
          x = (
            self.trans()
          )
          begin
             makeMany(x, false) 
          end
        rescue RuleFailure => ex
          self._pos = _p30
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Many'
      raise ex
    end
  end
  

  
  def Many1
    #throws RuleFailure
    begin
      _start = _pos; x = nil
      begin
        _p31 = _pos
        begin
          x = (
            self.trans()
          )
          begin
             makeMany(x, true)  
          end
        rescue RuleFailure => ex
          self._pos = _p31
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Many1'
      raise ex
    end
  end
  

  
  def Opt
    #throws RuleFailure
    begin
      _start = _pos; x = nil
      begin
        _p32 = _pos
        begin
          x = (
            self.trans()
          )
          begin
            
                  add_dict
                  add_expr(:EXPR, x)
                  render('opt')
                
          end
        rescue RuleFailure => ex
          self._pos = _p32
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Opt'
      raise ex
    end
  end
  

  
  def Not
    #throws RuleFailure
    begin
      _start = _pos; x = nil
      begin
        _p33 = _pos
        begin
          x = (
            self.trans()
          )
          begin
            
                  add_dict
                  add_expr(:EXPR, x)
                  render('not')
                
          end
        rescue RuleFailure => ex
          self._pos = _p33
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Not'
      raise ex
    end
  end
  

  
  def Peek
    #throws RuleFailure
    begin
      _start = _pos; x = nil
      begin
        _p34 = _pos
        begin
          x = (
            self.trans()
          )
          begin
            
                  add_dict
                  @dict.setVariable(:VAR, genvar)
                  add_expr(:EXPR, x)
                  render('peek')
                
          end
        rescue RuleFailure => ex
          self._pos = _p34
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Peek'
      raise ex
    end
  end
  

  
  def List
    #throws RuleFailure
    begin
      _start = _pos; x = nil
      begin
        _p35 = _pos
        begin
          x = (
            self.trans()
          )
          begin
            
                  add_dict
                  add_expr(:EXPR, x)
                  render('list')
                
          end
        rescue RuleFailure => ex
          self._pos = _p35
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'List'
      raise ex
    end
  end
  

  
  def Rule
    #throws RuleFailure
    begin
      _start = _pos; name = nil; args = nil; body = nil; annotations = nil
      begin
        _p36 = _pos
        begin
          name = (
            self._any()
          )
          args = (
            self._any()
          )
          body = (
            self.trans()
          )
          annotations = (
            self._any()
          )
          begin
            
                  @rules.add(name) if args.nil?
                  add_dict
                  @dict.setVariable(:RULE, name.toString)
                  @dict.setVariable(:MEMO_KEY, "#{@name}.#{name}")
                  @dict.showSection(:DEBUG) if @debug
                  @dict.setVariable(:ARGS, args.toString) if args
                  memoized = @auto_memo
                  type = nil
                  List(annotations).each do |_anno|
                    anno = List(_anno)
                    if "Memo".equals(anno.get(0))
                      memoized = true
                      type = anno.get(1)
                    elsif "Returns".equals(anno.get(0))
                      type = anno.get(1)
                    elsif "Scope".equals(anno.get(0))
                      saved_names = List(anno.get(1))
                      @dict.showSection(:SCOPE)
                      saved_names.each do |_name|
                        var_name = String(_name)
                        dict = @dict.addSection(:SCOPE_VARS)
                        dict.setVariable(:NAME, var_name)
                        dict.setVariable(:SIMPLE_NAME, var_name.replace('@', ''))
                      end
                    end
                  end
                  memoized = false if args
                  localsAsInit
                  @dict.setVariable(:CAST, type.toString) if type
                  if memoized
                    @dict.showSection(:MEMO)
                    if @left_recursion
                      @dict.showSection(:RECURSION)
                      @dict.setVariable(:MEMO_RULE, :memo_rule)
                      @dict.setVariable(:RULE_BODY, :recursive_rule)
                    else
                      @dict.showSection(:NO_RECURSION)
                      @dict.setVariable(:RULE_BODY, :memo_rule)
                    end
                    add_expr(:BODY, body, @dict.addSection(:RULE_BODY))
                  else
                    @dict.showSection(:UNMEMO)
                    @dict.showSection(:NO_RECURSION)
                    if type
                      @dict.setVariable(:RULE_BODY, :cast)
                      section = @dict.addSection(:RULE_BODY)
                      section.setVariable(:TYPE, type.toString)
                      add_expr(:EXPR, body, section)
                    else
                      add_expr(:RULE_BODY, body)
                    end
                  end
                  render('rule')
                
          end
        rescue RuleFailure => ex
          self._pos = _p36
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Rule'
      raise ex
    end
  end
  

  
  def Parser
    #throws RuleFailure
    begin
      _start = _pos; p = nil; n = nil; s = nil; xs = nil
      begin
        _p38 = _pos
        begin
          p = (
            self._any()
          )
          n = (
            self._any()
          )
          s = (
            self._any()
          )
          begin
             @name = String(n); @sname = String(s) 
          end
          xs = (
            begin
              as37 = ArrayList.new
              begin
                while true do
                  _li = Object(
                    self.trans()
                  )
                  as37.add(_li)
                end
              rescue RuleFailure; end
              as37
            end
          )
          begin
            
                  dict = add_dict
                  build_init
                  @rules.each do |name|
                    @dict.addSection(:RULE).setVariable(:RULE, String(name))
                  end
                  @dict.setVariable(:PARSER, @name)
                  @dict.setVariable(:SUPERCLASS, @sname)
                  List(xs).each do |expr|
                    @dict = dict.addSection(:BODY)
                    add_expr(:BODY, expr)
                  end
                  b = render('parser', dict)
                  reset
                  b
                
          end
        rescue RuleFailure => ex
          self._pos = _p38
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Parser'
      raise ex
    end
  end
  

  
  def Method
    #throws RuleFailure
    begin
      _start = _pos; name = nil; args = nil; body = nil; ismacro = nil; c = nil
      begin
        begin
          _p39 = _pos
          begin
            name = (
              self._any()
            )
            args = (
              self._any()
            )
            body = (
              self._any()
            )
            ismacro = (
              self._any()
            )
            begin
              
                             add_dict
                             @dict.setVariable(:NAME, name.toString)
                             @dict.setVariable(:ARGS, args.toString)
                             @dict.showSection(:MACRO) if ismacro
                             add_expr(:BODY, body)
                             render('method')
                           
            end
          rescue RuleFailure => ex
            self._pos = _p39
            raise ex
          end
        end
      rescue RuleFailure
        begin
          _p40 = _pos
          begin
            c = (
              self._any()
            )
            "  #{c}\n"
          rescue RuleFailure => ex
            self._pos = _p40
            raise ex
          end
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Method'
      raise ex
    end
  end
  

  
  def Field
    #throws RuleFailure
    begin
      _start = _pos; c = nil
      begin
        _p41 = _pos
        begin
          c = (
            self._any()
          )
          "  #{c}\n"
        rescue RuleFailure => ex
          self._pos = _p41
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Field'
      raise ex
    end
  end
  

  
  def Package
    #throws RuleFailure
    begin
      _start = _pos; c = nil
      begin
        _p42 = _pos
        begin
          c = (
            self._any()
          )
          begin
             @jpackage = String(c); ""; 
          end
        rescue RuleFailure => ex
          self._pos = _p42
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Package'
      raise ex
    end
  end
  

  
  def Import
    #throws RuleFailure
    begin
      _start = _pos; c = nil
      begin
        _p43 = _pos
        begin
          c = (
            self._any()
          )
          "#{c}\n"
        rescue RuleFailure => ex
          self._pos = _p43
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Import'
      raise ex
    end
  end
  

  
  def Class
    #throws RuleFailure
    begin
      _start = _pos; q = nil; d = nil; c = nil
      begin
        _p44 = _pos
        begin
          q = (
            self._any()
          )
          d = (
            self._any()
          )
          c = (
            self._any()
          )
          "#{d}\n#{c}\n end"
        rescue RuleFailure => ex
          self._pos = _p44
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Class'
      raise ex
    end
  end
  

  
  def Line
    #throws RuleFailure
    begin
      _start = _pos; ws = nil; x = nil
      begin
        _p45 = _pos
        begin
          ws = (
            self._any()
          )
          x = (
            self.trans()
          )
          begin
             ws.toString + x.toString 
          end
        rescue RuleFailure => ex
          self._pos = _p45
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'Line'
      raise ex
    end
  end
  

  
  def File
    #throws RuleFailure
    begin
      _start = _pos; xs = nil
      begin
        _p47 = _pos
        begin
          xs = (
            begin
              as46 = ArrayList.new
              begin
                while true do
                  _li = Object(
                    self.trans()
                  )
                  as46.add(_li)
                end
              rescue RuleFailure; end
              as46
            end
          )
          begin
            
                    "# generated by mmeta on #{Date.new}\n" +
                    "# do not modify, instead edit original .mmeta file\n" +
                    (@jpackage ? "#{@jpackage}\n": "") +
                    "import java.util.ArrayList\n" +
                    "import java.util.Date\n" +
                    "import java.util.List\n" +
                    "import java.util.EnumSet\n" +
                    (@embedded ? "" : "import mmeta.*\n") + join(xs)
                
          end
        rescue RuleFailure => ex
          self._pos = _p47
          raise ex
        end
      end
    rescue RuleFailure => ex
      ex.last = 'File'
      raise ex
    end
  end
  

  
  def start
    #throws RuleFailure
    begin
      _start = _pos; r = nil
      begin
        begin
          _p48 = _pos
          begin
            r = (
              self.destruct()
            )
            self.end()
            r
          rescue RuleFailure => ex
            self._pos = _p48
            raise ex
          end
        end
      rescue RuleFailure
        raise SyntaxError.new("", @error.last, _pos, _string, _list)
      end
    rescue RuleFailure => ex
      ex.last = 'start'
      raise ex
    end
  end
  

  def unescape(s:String)
    
          sb = StringBuilder.new
          i = 0
          while i < s.length
            if s.charAt(i) == 92 # ?\\
              i += 1
              c = s.substring(i, i + 1)
              if c.equals("n")
                sb.append("\n")
              elsif c == "s"
                sb.append("\s")
              elsif c == "r"
                sb.append("\r")
              elsif c == "t"
                sb.append("\t")
              elsif c == "v"
                sb.append("\v")
              elsif c == "f"
                sb.append("\f")
              elsif c == "b"
                sb.append("\b")
              elsif c == "a"
                sb.append("\a")
              elsif c == "e"
                sb.append("\e")
              else
                sb.append(c)
              end
            else
              sb.append(s.charAt(i))
            end
            i += 1
          end
          str = sb.toString
          ints = int[str.length]
          ints.length.times do |i|
            ints[i] = str.charAt(i)
          end
          ints
        
  end
  

  def compile_literal_string(_s:Object)
    
          s = unescape(String(_s))
          if s.length == 0
            "''"
          else
            add_dict
            @dict.setVariable(:VAR, "_p#{genvar}")
            @dict.setVariable(:STRING, String(_s))
            @dict.setVariable(:LENGTH, String.valueOf(s.length))
            s.each do |i|
              @dict.addSection(:CHAR).setVariable(:CHAR, String.valueOf(i))
            end
            render('string_literal')
          end
        
  end
  

  def lookup_token(name:Object)
    
          @tokens ||= ArrayList.new
          index = @tokens.indexOf(name)
          if index == -1
            index = @tokens.size
            @tokens.add(name)
          end
          return index
        
  end
  

  def lookup_range(first:Object, last:Object)
    
          key = "#{first},#{last}"
          val = String(@ranges.get(key))
          if val.nil?
            val = "@_trange#{@ranges.size}"
            @ranges.put(key, val)
          end
          val
        
  end
  

  def build_init()
    
          @ranges.keySet.each do |key|
            dict = @dict.addSection(:RANGE)
            tokens = String(key).split(",")
            dict.setVariable(:FIRST, tokens[0])
            dict.setVariable(:LAST, tokens[1])
            dict.setVariable(:NAME, @ranges.get(key).toString)
          end
        
  end
  

  def render(template:String, dict:TemplateDataDictionary=nil)
    
          user_path = String(@user_template_paths.get(template))
          tpl = if user_path
            @custom_templates.getTemplate(user_path)
          else
            @templates.getTemplate(template)
          end
          dict ||= @dict
          begin
            tpl.renderToString(dict)
          rescue StackOverflowError
            raise "StackOverflowError caught"
          end
        
  end
  

  def add_dict()
    
          @dict = TemplateDataDictionary(TemplateDictionary.create)
          # @dict.enableDebugAnnotations
        
  end
  

  def add_expr(name:String, expr:Object, dict:TemplateDataDictionary=nil)
    
          dict ||= @dict
          dict.setVariable(name, :simple_expr)
          dict.addSection(name).setVariable(:EXPR, expr.nil? ? "" : expr.toString)
        
  end
  


  def _jump(r:String)
    return destruct() if (r == "destruct")
    return trans() if (r == "trans")
    return HList() if (r == "HList")
    return HConcat() if (r == "HConcat")
    return HStr() if (r == "HStr")
    return HLit() if (r == "HLit")
    return Node() if (r == "Node")
    return Error() if (r == "Error")
    return Set() if (r == "Set")
    return Str() if (r == "Str")
    return Sym() if (r == "Sym")
    return App() if (r == "App")
    return Dot() if (r == "Dot")
    return SAct() if (r == "SAct")
    return Act() if (r == "Act")
    return Pred() if (r == "Pred")
    return SynPred() if (r == "SynPred")
    return Token() if (r == "Token")
    return TokenRange() if (r == "TokenRange")
    return TLit() if (r == "TLit")
    return Or() if (r == "Or")
    return And() if (r == "And")
    return Many() if (r == "Many")
    return Many1() if (r == "Many1")
    return Opt() if (r == "Opt")
    return Not() if (r == "Not")
    return Peek() if (r == "Peek")
    return List() if (r == "List")
    return Rule() if (r == "Rule")
    return Parser() if (r == "Parser")
    return Method() if (r == "Method")
    return Field() if (r == "Field")
    return Package() if (r == "Package")
    return Import() if (r == "Import")
    return Class() if (r == "Class")
    return Line() if (r == "Line")
    return File() if (r == "File")
    return start() if (r == "start")
    super(r)
  end

  def _has(r:String)
    return true if (r == "destruct")
    return true if (r == "trans")
    return true if (r == "HList")
    return true if (r == "HConcat")
    return true if (r == "HStr")
    return true if (r == "HLit")
    return true if (r == "Node")
    return true if (r == "Error")
    return true if (r == "Set")
    return true if (r == "Str")
    return true if (r == "Sym")
    return true if (r == "App")
    return true if (r == "Dot")
    return true if (r == "SAct")
    return true if (r == "Act")
    return true if (r == "Pred")
    return true if (r == "SynPred")
    return true if (r == "Token")
    return true if (r == "TokenRange")
    return true if (r == "TLit")
    return true if (r == "Or")
    return true if (r == "And")
    return true if (r == "Many")
    return true if (r == "Many1")
    return true if (r == "Opt")
    return true if (r == "Not")
    return true if (r == "Peek")
    return true if (r == "List")
    return true if (r == "Rule")
    return true if (r == "Parser")
    return true if (r == "Method")
    return true if (r == "Field")
    return true if (r == "Package")
    return true if (r == "Import")
    return true if (r == "Class")
    return true if (r == "Line")
    return true if (r == "File")
    return true if (r == "start")
    super(r)
  end
end
