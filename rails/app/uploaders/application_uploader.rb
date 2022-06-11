class ApplicationUploader < Shrine
  plugin :validation_helpers
  Attacher.validate do
    validate_min_size 1.bytes, message: "must not be empty"
    validate_max_size 10.megabytes
  end

  plugin :determine_mime_type
  plugin :infer_extension, force: true
  plugin :remove_attachment

  plugin :upload_endpoint, url: true, max_size: 10.megabytes
  plugin :presign_endpoint, presign_options: -> (request) {
    # Uppy will send the "filename" and "type" query parameters
    filename = request.params["filename"]
    type     = request.params["type"] || 'application/octet-stream'

    {
      content_disposition:    ContentDisposition.inline(filename), # set download filename
      content_type:           type,                                # set content type (required if using DigitalOcean Spaces)
      content_length_range:   0..(20.megabytes),                   # limit upload size to 20 MB
    }
  }

  # plugin :presign_endpoint,
  #   # Note: https://shrinerb.com/rdoc/classes/Shrine/Plugins/PresignEndpoint.html#module-Shrine::Plugins::PresignEndpoint-label-Options
  #   presign_options: -> (request) {
  #     # Uppy will send the "filename" and "type" query parameters
  #     filename = request.params["filename"]
  #     type     = request.params["type"]

  #     {
  #       content_disposition:    ContentDisposition.inline(filename), # set download filename
  #       content_type:           type,                                # set content type (defaults to "application/octet-stream")
  #       content_length_range:   0..(20.megabytes),                   # limit upload size to 20 MB
  #     }
  #   },
  #   presign_location: -> (request) do
  #     location_extension = File.extname(request.params["filename"])
  #     ApplicationUploader.generate_random_location(location_extension)
  #   end

  # plugin :pretty_location
  # https://groups.google.com/forum/#!topic/ruby-shrine/qc7y7B-2byM
  # https://www.rubydoc.info/gems/shrine/1.4.2/Shrine%2FPlugins%2FBase%2FInstanceMethods:generate_location
  # def generate_location(io, context = {}) # override
  #   location_filename = super
  #   location_extension = File.extname(location_filename)
  #   ApplicationUploader.generate_random_location(location_extension)
  # end

  # private
  #   def self.generate_random_location(extension)
  #     location_basename = SecureRandom.hex
  #     [
  #       location_basename[0..1],
  #       location_basename[2..3],
  #       location_basename[4..-1] + '.' + extension.sub(/^[.]/, '')
  #     ].compact.join("/")
  #   end
end
