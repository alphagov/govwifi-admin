module Gateways
  class CertificateRepositoryS3
    def initialize(s3_cert_bucket = ENV.fetch("S3_TRUSTED_CERTS_BUCKET"), s3_trusted_cert_path = ENV.fetch("S3_TRUSTED_CERTS_PATH_KEY"), s3_root_cert_path = ENV.fetch("S3_ROOT_CERTS_PATH_KEY"))
      @s3_cert_bucket = s3_cert_bucket
      @s3_trusted_cert_path = s3_trusted_cert_path
      @s3_root_cert_path = s3_root_cert_path
      @client = Aws::S3::Client.new(config)
    end

    def store_certificate(organisation_id, cert_name, raw_data, is_root_cert)
      organisation_cert_name = construct_organisation_cert_name(organisation_id, cert_name)
      key = construct_s3_cert_path(organisation_cert_name, is_root_cert)

      @client.put_object(body: StringIO.new(raw_data), bucket: @s3_cert_bucket, key:)
    end

    def delete_certificate(organisation_id, cert_name, is_root_cert)
      organisation_cert_name = construct_organisation_cert_name(organisation_id, cert_name)
      key = construct_s3_cert_path(organisation_cert_name, is_root_cert)
      archive_full_path = construct_s3_archive_path_inc_bucket(organisation_cert_name, is_root_cert)

      obj = Aws::S3::Object.new(bucket_name: @s3_cert_bucket, key:, client: @client)
      obj.move_to(archive_full_path)
    end

    def construct_s3_archive_path_inc_bucket(organisation_cert_name, is_root_cert)
      File.join(@s3_cert_bucket, is_root_cert ? @s3_root_cert_path : @s3_trusted_cert_path, "archive", organisation_cert_name)
    end

    def construct_s3_cert_path(organisation_cert_name, is_root_cert)
      File.join(is_root_cert ? @s3_root_cert_path : @s3_trusted_cert_path, organisation_cert_name)
    end

    def construct_organisation_cert_name(organisation_id, cert_name)
      "#{organisation_id}_#{cert_name}.pem"
    end

  private

    DEFAULT_REGION = "eu-west-2".freeze

    def config
      { region: DEFAULT_REGION }.merge(Rails.application.config.s3_aws_config)
    end
  end
end
