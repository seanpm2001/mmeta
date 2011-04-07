require 'ant'
require 'rake/testtask'

if File.exist?('../mirah/lib/mirah_task.rb')
  $:.unshift '../mirah/lib'
end
require 'mirah_task'

task :default => :test
task :jar => 'dist/mmeta.jar'

task :clean do
  ant.delete :quiet => true, :dir => 'build'
  ant.delete :quiet => true, :dir => 'dist'
end

task :bootstrap => ['dist/mmeta.jar'] do
  runjava 'dist/jmeta.jar', 'boot/JMetaParser'
  runjava 'dist/jmeta.jar', 'boot/JMetaCompiler'
  runjava 'dist/mmeta.jar', 'boot/mirah_compiler.mmeta', 'boot/mirah_compiler.mirah'
end

file 'dist/jmeta-runtime.jar' => Dir.glob('jmeta/*.{java,mirah}') + ['build/runtime', 'dist'] do
  ENV['BS_CHECK_CLASSES'] = 'true'
  mirahc('jmeta/ast.mirah', :dest => 'build/runtime')
  ant.javac :srcDir=>'jmeta', :destDir=>'build/runtime', :debug=>true
  ant.jar :destfile=>'dist/jmeta-runtime.jar', :basedir=>'build/runtime'
end

file 'dist/jmeta.jar' => ['dist/jmeta-runtime.jar',
                          'boot/JMetaParser.java',
                          'boot/JMetaCompiler.java',
                          'build/boot/jmeta'] do
  cp 'boot/JMetaParser.java', 'build/boot/jmeta/'
  cp 'boot/JMetaCompiler.java', 'build/boot/jmeta/'
  ant.javac :srcDir => 'build/boot', :classpath=>'dist/jmeta-runtime.jar', :debug=>true
  ant.jar :destfile=>'dist/jmeta.jar' do
    fileset :dir=>"build/boot", :includes=>"jmeta/*.class"
    fileset :dir=>"build/runtime", :includes=>"jmeta/*.class"
    manifest do
      attribute :name=>"Main-Class", :value=>"jmeta.JMetaParser"
    end
  end
end

file 'build/boot/jmeta/MMetaCompiler.class' => ['boot/mirah_compiler.mirah'] do
  cp 'boot/mirah_compiler.mirah', 'build/boot/jmeta/'
  mirahc('jmeta/mirah_compiler.mirah',
         :dir => 'build/boot',
         :dest => 'build/boot',
         :options => ['--classpath', 'dist/jmeta.jar:/Developer/ST-4.0.jar:/Developer/antlr-3.3/lib/antlr-3.3-complete.jar'])
end

file 'dist/mmeta.jar' => ['dist/jmeta.jar',
                          'build/boot/jmeta/MMetaCompiler.class',
                          'boot/mmeta_compiler.stg'] do
  cp 'boot/mmeta_compiler.stg', 'build/boot/jmeta/'
  ant.jar :destfile=>'dist/mmeta.jar' do
    fileset :dir=>"build/boot", :includes=>"jmeta/*.class"
    fileset :dir=>"build/runtime", :includes=>"jmeta/*.class"
    fileset :dir=>"build/boot", :includes=>"jmeta/*.stg"
    zipfileset :includes=>"**/*.class", :src=>"/Developer/ST-4.0.jar"
    zipfileset :includes=>"**/*.class", :src=>"/Developer/antlr-3.3/lib/antlr-3.3-complete.jar"
    manifest do
      attribute :name=>"Main-Class", :value=>"jmeta.MMetaCompiler"
    end
  end
end

namespace :test do
  task :compile => ['dist/mmeta.jar', 'build/test'] do
    cp "test/MirahLexer.java", "build/test/"
    cp "test/Tokens.java", "build/test/"
    ant.javac :srcDir => 'build/test', :classpath=>'dist/jmeta-runtime.jar', :debug=>true
    mirahc 'test', :dir=>'build', :dest=>'build',
        :options=>['--classpath', "dist/jmeta-runtime.jar:#{Dir.pwd}/build"]
  end
  task :calc => :'test:compile' do
    runjava('Calculator', '4 * 3 - 2', :outputproperty=>'test.output',
            :classpath=>'dist/jmeta-runtime.jar:build/test', :failonerror=>false)
    if ant.properties['test.output'].to_s.strip == '10'
      puts "Calculator passed"
    else
      puts "Expected calculator result 10, got #{ant.properties['test.output']}"
      exit(1)
    end
  end
  task :mcalc => :'test:compile' do
    runjava('test.Calculator2', '4 * 3 - 2', :outputproperty=>'test.output2',
            :classpath=>'dist/jmeta-runtime.jar:build', :failonerror=>false)
    if ant.properties['test.output2'].to_s.strip == '10'
      puts "Mirah Calculator passed"
    else
      puts "Expected calculator result 10, got #{ant.properties['test.output2']}"
      exit(1)
    end
  end
  Rake::TestTask.new :parser do |t|
    t.libs << 'build/test'
    t.test_files = FileList['test/test_parser.rb']
  end
end

Dir.glob('test/*.jmeta').each do |f|
  name = File.basename(f, '.jmeta')
  task(:'test:compile').enhance ["build/test/#{name}.java"]
  file "build/test/#{name}.java" => [f, 'dist/jmeta.jar', 'build/test'] do
    cp "test/#{name}.jmeta", "build/test/"
    runjava 'dist/jmeta.jar', "build/test/#{name}"
  end
end

def test_grammar(name, *options)
  task(:'test:compile').enhance ["build/test/#{name}.mirah"]
  file "build/test/#{name}.mirah" => ["test/#{name}.mmeta", 'dist/mmeta.jar', 'build/test'] do
    cp "test/#{name}.mmeta", "build/test/"
    args = ['dist/mmeta.jar', *options]
    args.concat ["build/test/#{name}.mmeta", "build/test/#{name}.mirah"]
    runjava  *args
  end
end

test_grammar('MirahCalculator', '--auto_memo', '--recursion')
#test_grammar('Mirah')
test_grammar('TestParser')

# TODO: Set mcalc to use left recursion and auto memoization
task :test => [:'test:calc',
               :'test:mcalc',
               :'test:parser',
               ]

directory 'dist'
directory 'build/test'
directory 'build/jmeta'
directory 'build/runtime'
directory 'build/boot/jmeta'

def runjava(jar, *args)
  options = {:failonerror => true, :fork => true}
  if jar =~ /\.jar$/
    options[:jar] = jar
  else
    options[:classname] = jar
  end
  options.merge!(args.pop) if args[-1].kind_of?(Hash)
  puts "java #{jar} " + args.join(' ')
  ant.java options do
    args.each do |value|
      arg :value => value
    end
  end
end