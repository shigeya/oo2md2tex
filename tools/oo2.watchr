# oo2tex continuous runner script using watchr using growlnotify
# based on :  https://gist.github.com/797853
#
# run this script via 'watchr' ( https://github.com/mynyml/watchr ) by:
#  watchr oo2.watchr
#
# When user modify some *.oo3 file, make will run.
#
# Interface:
#   On single SIGINT hit, make will run.
#   On two SIGINT hit in sequence, exit.
#   On SIGQUIT, 'make realclean; make' will run.
#
if RUBY_VERSION >= "1.9"  # multibyte encoding only supported in Ruby 1.9
  Encoding.default_external = "UTF-8"
end

# To use image for growl, place files 'success.png' and 'failed.png' into 
# directory and set $image_dir
$image_dir = nil # "~/images" 

ENV["WATCHR"] = "1"

ARGV.shift
all = ARGV.join(' ')

def clear_screen
#    system 'clear'
    puts ""
    puts ""
    puts ""
    puts "-" * 80
end

def growl(success, message)
  growlnotify = `which growlnotify`.chomp
  title = "Make run " + (success ? "OK" : "Failed")
  image_opt = ""
  if $image_dir != nil and File.directory?(File.expand_path($image_dir))
    image_path = success ? "#{$image_dir}/success.png" : "#{$image_dir}/failed.png"
    image_opt = "--image '" + File.expand_path(image_path)+  "'"
  end
  options = "-w -n Watchr #{image_opt} -m '#{message}' '#{title}'"
  system "#{growlnotify} #{options} &"
end

def growl_stat(result, elapsed)
end

def run(cmd)
  puts(cmd)
  system(cmd)
end

def make(target = "")
  puts "** make #{target}"
  clear_screen
  start_time = Time.now
  result = run(%Q(make #{target}))
  end_time = Time.now
  elapsed = end_time - start_time
  growl result, "Elapsed #{elapsed} secs"
  puts "=> " + (result == true ? "Success" : "Failure")
  result
end


ignore_list = [ ]
open(".gitignore").each do |l|
  l.chomp!
  next if l =~ /^#/ or l =~ /^\s*$/
  ignore_list.push(l)
end

#watch('.*') { |x| puts "!! #{x}" }
watch('.*\.oo3') { |x| make(all) if ignore_list.grep(x.to_s).size == 0 }
watch('.*\.tex') { |x| make(all) if ignore_list.grep(x.to_s).size == 0 }
watch('\./Makefile') { |x| make(all) }
watch('\./Drawings/.*\.(pdf|bb)') { |x| make(all) }

@interrupted = false

puts "--- running 'make all' first time ---"
make(all)

# Ctrl-\
Signal.trap 'QUIT' do
  puts " --- Running make clean - then make ---\n\n"
  make("realclean")
  make(all)
end

# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    @wants_to_quit = true
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 2
    # raise Interrupt, nil # let the run loop catch it
    make(all)
    @interrupted = false
  end
end

# Local Variables:
# mode: ruby
# End:
