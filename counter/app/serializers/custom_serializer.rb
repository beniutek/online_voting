#
# Very simple serializer for resoucers
# Example implementation can be seen in VoteSerializer
#
class CustomSerializer
  attr_accessor :resource

  def initialize(resource)
    @resource = resource
  end

  def self.attributes(*attrs)
    @@attributes = attrs
  end

  def to_h
    h = {}
    @@attributes.each do |attr|
      h[attr] = resource.send(attr)
    end
    h
  end

  def to_json
    to_h.to_json
  end

  def as_json
    to_h.as_json
  end
end
