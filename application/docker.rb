require 'pp'

class MCollective::Application::Docker<MCollective::Application
   description "Client side application for the MCollective Docker agent"

   usage "mco docker [options] [command] [extra args]"
   usage "mco docker [options] [command] [extra args]"

   option	:id,
		:description	=> "Container or Images ID, depending on command used",
		:arguments	=> [ "-i", "--id ID" ],
		:type		=> String,
		:required	=> false
		
   option	:all,
		:description	=> "List all containers, not only running ones.",
		:arguments	=> [ "-a", "--all" ],
		:required	=> false
		
   option	:limit,
		:description	=> "Limit output to N entries max.",
		:arguments	=> [ "-l", "--limit N" ],
		:required	=> false
		
   def post_option_parser(configuration)
      unless ARGV.empty?
         configuration[:command] = ARGV.shift
      else
         STDERR.puts "Please specify a command on the command line."
         exit 1
      end

 	if configuration.has_key? :all then
		configuration[:all] = true
	end
   end
 
   def main
	# obtain rpc client ref
	mc = rpcclient("docker")

	# execute command by handler
	run_command(mc,configuration)

	# summary and exit
	printrpcstats
	halt mc.stats
   end

   def run_command(mc,configuration)
	# validate command name
	method = "run_command_#{configuration[:command]}"
	send(method,mc,configuration)
   end

	
   def run_command_ps(mc,c)
	opts = {}
	if c[:all] then
		opts[:all] = true
	end
	if c[:limit] then
		opts[:limit] = c[:limit]
	end

	rpc_res = mc.ps(opts) || []
	rpc_res.each do |rpc_obj|
		result = rpc_obj.results || {}
		sender = result[:sender]
		data = result[:data] || {}
		# todo: sort by sender, then by created timestamp

		puts "SERVER              ID                  IMAGE               COMMAND             CREATED             STATUS              PORTS"

		(data[:containers] || []).each do |entry|
			e = entry.inject({}) { |n,(k,v)| n.store(k,fmt0(v)); n }
			puts format("%-19s %-19s %-19s %-19s %-19s %-19s %-19s", fmt0(sender), 
				fmt0(e["Id"],12),
				e["Image"],
				e["Command"],
				e["Created"],
				e["Status"],
				e["Ports"]
			)
		end
	end
   end

   def run_command_images(mc,c)
	rpc_res = mc.images || []
	rpc_res.each do |rpc_obj|
		result = rpc_obj.results || {}
		sender = result[:sender]
		data = result[:data] || {}
		# todo: sort by sender, then by created timestamp

		puts "SERVER              REPOSITORY               TAG                 ID                  CREATED"

		(data[:images] || []).each do |e|
			puts format("%-19s %-24s %-19s %-19s %-19s", fmt0(sender), 
				fmt0(e["Repository"],24),
				fmt0(e["Tag"],20),
				fmt0(e["Id"],12),
				fmt0(e["Created"],20)
			)
		end
	end
   end

   private
	def fmt0(s,n=19)
		return "" unless s
		return s[0..n-1] if s.size >= n
		s
	end
end
