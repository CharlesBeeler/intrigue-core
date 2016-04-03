require 'towerdata_api'

module Intrigue
class SearchTowerdataTask < BaseTask

  def metadata
    {
      :name => "search_towerdata",
      :pretty_name => "Search Towerdata",
      :authors => ["jcran"],
      :description => "This task hits the Towerdata API and finds info based on an email address.",
      :references => [],
      :allowed_types => ["EmailAddress"],
      :example_entities => [{"type" => "EmailAddress", "attributes" => {"name" => "x@x.com"}}],
      :allowed_options => [],
      :created_types => ["Info"]
    }
  end

  def run
    super

    entity_name = _get_entity_attribute "name"
    api_key = _get_global_config "towerdata_api_key"

    begin
      api = TowerDataApi::Api.new(api_key) # Set API key here
      hash = api.query_by_email(entity_name)
      _create_entity "Info", {
        "name" => "Towerdata details for #{entity_name}",
        "details" => hash }
    rescue Exception => e
      @task_result.logger.log_error e.message
    end

  end # end run()

end
end