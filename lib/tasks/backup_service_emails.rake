namespace :backup do
  desc "Backup Service Emails"
  task service_emails: :environment do
    UseCases::BackupServiceEmails.new(
      writer: Gateways::GoogleDrive.new(credentials: ENV["SERVICE_ACCOUNT_BACKUP_CREDENTIALS"]),
    ).execute
  end
end
