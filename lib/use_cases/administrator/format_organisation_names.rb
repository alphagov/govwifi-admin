module UseCases
  module Administrator
    class FormatOrganisationNames
      def execute(organisation_names)
        StringIO.new(organisation_names.to_yaml)
      end
    end
  end
end
