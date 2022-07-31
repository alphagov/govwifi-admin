module BulkUploadHelper
  def upload_error_id_helper(index, *labels)
    "#{labels.join('-')}-error-#{index}".gsub!(/\W/, "-").downcase!
  end
end
