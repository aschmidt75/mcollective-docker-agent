require 'docker'
include Docker

module MCollective
  module Agent
    class Docker<RPC::Agent
	metadata    :name        => "Docker Access Agent",
	            :description => "Agent to access the Docker API via MCollective",
	            :author      => "Andreas Schmidt [@aschmidt75]",
	            :license     => "Apache 2",
	            :version     => "1.0",
	            :url         => "http://github.com...",
	            :timeout     => 60


	# query all containers, retrieve same information
	# as docker ps
	action "ps" do
		logger.debug "docker/ps"

		begin
			options = {}
			options[:all] = true 		if request[:all] 
			v = request[:limit]
			options[:limit] = v.to_i	if v 

			[ :beforeId, :sinceId ].each do |sym|	
				if request[sym] then
					validate sym, String
					validate sym, /^[0-9a-fA-F]+$/
					options[sym] = request[sym]
				end
			end

			logger.debug "docker/ps options=#{options}"
			reply[:containers] = get_containers.list(options)
		rescue => e
			reply.fail! "Error querying docker api (ps), #{e}"
			logger.error e
		end
		logger.debug "docker/ps done."
	end

	# retrieve container information, given by container id
	action "inspect" do
		validate :id, String
		validate :id, /^[0-9a-fA-F]+$/

		begin
			id = request[:id]
			logger.debug "docker/inspect, id=#{id}"
			
			reply[:details] = get_containers.show(id)
		rescue => e
			reply.fail! "Error querying docker api (inspect), #{e}"
			logger.error e
		end
		logger.debug "docker/inspect done."
	end

	# retrieve container fs changes
	action "diff" do
		validate :id, String
		validate :id, /^[0-9a-fA-F]+$/

		begin
			id = request[:id]
			logger.debug "docker/diff, id=#{id}"

			reply[:changes] = get_containers.changes(id)
		rescue => e
			reply.fail! "Error querying docker api (diff), #{e}"
			logger.error e
		end
		logger.debug "docker/diff done."
	end

	# remove a (running) container
	action "rm" do
		validate :id, String
		validate :id, /^[0-9a-fA-F]+$/

		begin
			id = request[:id]
			logger.debug "docker/rm, id=#{id}"

			reply[:changes] = get_containers.remove(id)
		rescue => e
			reply.fail! "Error querying docker api (remove), #{e}"
			logger.error e
		end
		logger.debug "docker/rm done."
	end

	[ "start", "stop", "kill", "restart" ].each do |c|
		action c do
			validate :id, String
			validate :id, /^[0-9a-fA-F]+$/
	
			begin
				id = request[:id]
				logger.debug "docker/#{c}, id=#{id}"
	
				reply[:exitcode] = get_containers.send(c,id)

				logger.debug "done with cmd=#{c} on id=#{id}"
			rescue => e
				reply.fail! "Error querying docker api (#{c}), #{e}"
				logger.error e
			end
			logger.debug "docker/#{c} done."
		end
	end


	action "images" do
		logger.debug "docker/images"
		begin
			reply[:images] = get_images.list
		rescue => e
			reply.fail! "Error querying docker api (images), #{e}"
			logger.error e
		end
		logger.debug "docker/images done."
	end

      private
      def get_containers
	config = { :base_url => 'http://localhost:4243' }
	docker = API.new(config)
	docker.containers
      end
      def get_images
	config = { :base_url => 'http://localhost:4243' }
	docker = API.new(config)
	docker.images
      end
    end
  end
end
# vi:tabstop=2:expandtab:ai
