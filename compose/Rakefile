require 'yaml'
require 'fileutils'

desc 'Remove local Docker volume directories for stack recreation'
task :cleanup do
  compose_dir = File.expand_path(File.dirname(__FILE__))
  compose_hash = YAML.load_file("#{compose_dir}/docker-compose.yml")
  services = compose_hash['services'].keys

  services.each do |service|
    STDOUT.puts "Removing #{service}'s volume directory"
    path_removed = FileUtils.rm_rf("#{compose_dir}/#{service}")
    puts "Removed: #{path_removed.first}"
    puts
  end
end
