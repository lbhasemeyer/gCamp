class TrackerAPI

  def initialize
    @conn = Faraday.new(:url => 'https://www.pivotaltracker.com')
  end

  def projects(tracker_token)
    return [] if tracker_token.nil?
    response = @conn.get do |req|
      req.url "/services/v5/projects"
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-TrackerToken'] = tracker_token
    end
    if response.success?
      JSON.parse(response.body, symbolize_names: true)
    else
      []
    end
  end

  def project(project_id, tracker_token)
    return [] if tracker_token.nil?
    response = @conn.get do |req|
      req.url "/services/v5/projects/#{project_id}"
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-TrackerToken'] = tracker_token
    end
    if response.success?
      JSON.parse(response.body, symbolize_names: true)
    else
      []
    end
  end

  def stories(tracker_id, tracker_token)
    return [] if tracker_token.nil?
    response = @conn.get do |req|
      req.url "services/v5/projects/#{tracker_id}/stories?limit=500"
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-TrackerToken'] = tracker_token
    end
    JSON.parse(response.body, symbolize_names: true)
  end

end
