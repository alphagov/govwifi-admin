module UseCases
  module Administrator
    class FormatOrganisationNames
      def execute(organisation_names)
        organisation_names_list(organisation_names)
      end

    private

      def organisation_names_list(organisation_names)
        data = StringIO.new(organisation_names.to_yaml)
        data
      end
    end
  end
end
