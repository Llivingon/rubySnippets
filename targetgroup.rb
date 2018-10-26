module Serverspec
  module Type
    module AWS
      # The ElasticLoadBalancing module contains the ElasticLoadBalancing API
      # resources
      module ElasticLoadBalancingV2
        # The LoadBalancer class exposes the ElasticLoadBalancing::LoadBalancer
        # resources
        class LoadBalancerRule < Base
          # AWS SDK for Ruby v2 Aws::ElasticLoadBalancing::LoadBalancerRule wrapper
          # for initializing a LoadBalancerRules resource
          # @param alb_name [String] The name of the LoadBalancer
          # rubocop:disable LineLength
          # @param instance [Class] Aws::ElasticLoadBalancing::LoadBalancerRule instance
          # rubocop:enable LineLength
          # @raise [RuntimeError] if albs.nil?
          # @raise [RuntimeError] if albs.length == 0
          # @raise [RuntimeError] if albs.length > 1
          def initialize(rule_arn, instance = nil)
            check_init_arg(
              'rule_arn',
              'ElasticLoadBalancingV2::LoadBalancerRule',
              alb_arn
            )
            @alb_arn = alb_arn
            get_instance instance
            get_rule rule_arn
          end

                    
          # Information about the health checks conducted on the load balancer
          # @return [Hash]
          def target_health_check
            @rule_details
          end
          
          private

          # @private
          def get_rule(rule_arn)
            rule_details = @aws.describe_rules(
              listener_arn: [rule_arn]
            ).rules
            check_length 'rule details', rule_details
            @rule_details = rule_details[0]
          end
          
          # @private
          def get_instance(instance)
            @aws = (
              instance.nil? ? Aws::ElasticLoadBalancingV2::Client.new : instance
            )
          end
        end
      end
    end
  end
end
