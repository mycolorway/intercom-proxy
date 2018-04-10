class IntercomResponseError < RuntimeError
  attr_reader :response

  def initialize(response)
    @response = response
  end
end
