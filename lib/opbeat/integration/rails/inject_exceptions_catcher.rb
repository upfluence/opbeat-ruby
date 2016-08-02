module Opbeat
  module Integration
    module Rails
      module InjectExceptionsCatcher
        def self.included(cls)
          cls.send(:alias_method_chain, :render_exception, :opbeat)
        end

        def render_exception_with_opbeat(request, exception)
          begin
            Opbeat.report(exception, rack_env: request.env) if Opbeat.started?
          rescue
            ::Rails::logger.error "** [Opbeat] Error capturing or sending exception #{$!}"
            ::Rails::logger.debug $!.backtrace.join("\n")
          end

          render_exception_without_opbeat(request, exception)
        end
      end
    end
  end
end

