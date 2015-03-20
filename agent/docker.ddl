metadata    :name        => "Docker Access Agent",
            :description => "Agent to access the Docker API via MCollective",
            :author      => "Andreas Schmidt [@aschmidt75]",
            :license     => "Apache 2",
            :version     => "1.0",
            :url         => "http://github.com...",
            :timeout     => 60


action "ps", :description => "Retrieve information about running containers" do

    input :all,
        :description    => "Show all containers, not only running ones",
        :optional       => true,
        :display_as     => "Show All",
        :type           => :boolean,
        :prompt         => "Show All"

    input :limit,
        :description    => "Limit result set",
        :prompt         => "Limit results",
        :display_as     => "Limit results",
        :optional       => true,
        :type           => :integer

    input :sinceId,
        :prompt         => "Show only containers created since containers with Id",
        :description    => "Show only containers created since containers with Id",
        :display_as     => "Since ID",
        :type           => :string,
        :validation     => '^[a-fA-F0-9]+$',
        :optional       => true,
        :maxlength      => 12

    input :beforeId,
        :prompt         => "Show only containers created since containers with Id",
        :description    => "Show only containers created before containers with Id",
        :display_as     => "Before ID",
        :type           => :string,
        :validation     => '^[a-fA-F0-9]+$',
        :optional       => true,
        :maxlength      => 12

    output :containers,
        :description    => "Output from API call, map of containers with detail data",
        :display_as     => "Containers"
end

action "inspect", :description => "Inspect container details" do
    display :always

    input :id,
        :description    => "Id",
        :display_as     => "Container ID",
        :type           => :string,
        :validation     => '^[a-fA-F0-9]+$',
        :optional       => false,
        :maxlength      => 12

    output :details,
        :description    => "Container details as map",
        :display_as     => "Details"
end

action "diff", :description => "Show container changes" do
    display :always

    input :id,
        :description    => "Id",
        :prompt         => "Container ID",
        :display_as     => "Container ID",
        :type           => :string,
        :validation     => '^[a-fA-F0-9]+$',
        :optional       => false,
        :maxlength      => 12

    output :changes,
        :description    => "Container changes as map",
        :display_as     => "Changes"
end

action "start", :description => "Start a previously stopped container" do
    display :always

    input :id,
        :description=> "Id",
        :prompt     => "Container ID",
        :display_as => "Container ID",
        :type       => :string,
        :validation => '^[a-fA-F0-9]+$',
        :optional   => false,
        :maxlength  => 12

    output :exitcode,
        :description    => "return code of action",
        :display_as     => "exitcode"
end

action "stop", :description => "Stop a running container" do
    display :always

    input :id,
        :description=> "Id",
        :prompt     => "Container ID",
        :display_as => "Container ID",
        :type       => :string,
        :validation => '^[a-fA-F0-9]+$',
        :optional   => false,
        :maxlength  => 12

    output :exitcode,
        :description    => "return code of action",
        :display_as     => "exitcode"
end

action "kill", :description => "Kill a running container" do
    display :always

    input :id,
        :description=> "Id",
        :prompt     => "Container ID",
        :display_as => "Container ID",
        :type       => :string,
        :validation => '^[a-fA-F0-9]+$',
        :optional   => :false,
        :maxlength  => 12

    output :exitcode,
        :description    => "return code of action",
        :display_as     => "exitcode"
end

action "restart", :description => "Restart a running container" do
    display :always

    input :id,
        :description=> "Id",
        :prompt     => "Container ID",
        :display_as => "Container ID",
        :type       => :string,
        :validation => '^[a-fA-F0-9]+$',
        :optional   => :false,
        :maxlength  => 12

    output :exitcode,
        :description    => "return code of action",
        :display_as     => "exitcode"
end

action "images", :description => "Retrieve information about all images on a host" do

    output :images,
        :description    => "Output from API call, map of images with detail data",
        :display_as     => "Images"
end

