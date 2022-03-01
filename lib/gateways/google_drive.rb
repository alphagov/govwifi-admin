require "google/apis/drive_v3"

module Gateways
  class GoogleDrive
    SCOPE = "https://www.googleapis.com/auth/drive".freeze

    def initialize(credentials:)
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: StringIO.new(credentials),
        scope: SCOPE,
      )

      @service = Google::Apis::DriveV3::DriveService.new
      @service.authorization = authorizer
    end

    def write(file_name:, folder_name:, upload_source:, mime_type: "text/plain")
      file = Google::Apis::DriveV3::File.new
      file.name = file_name
      file.mime_type = mime_type

      drive_file = @service.create_file(file, upload_source:)

      if folder_name
        folder = @service.list_files(q: "name = '#{folder_name}' and mimeType = 'application/vnd.google-apps.folder'")&.files&.first
        if folder
          @service.update_file(drive_file.id, nil, add_parents: folder.id)
        end
      end
    end
  end
end
