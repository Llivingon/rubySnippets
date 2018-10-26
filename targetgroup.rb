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
          # for initializing a LoadBalancerRule resource
          # @param alb_name [String] The arn of the Rule
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

          # Indicates whether rule is_default
          # @return [Boolean]
          def is_default
            @rule_details.is_default == true
          end
          
          # Information about the priority on the rule
          # @return [String]
          def priority
            @rule_details.priority
          end
          
          # Information about the action type on the rule
          # @return [String]
          def action_type
            @rule_details.actions[0].type
          end          
          
          # Information about the target group arn on the rule
          # @return [String]
          def targetgroup_arn
            @rule_details.actions[0].target_group_arn
          end          
          
          # Information about the conditions on the rule
          # @return [String]
          def condition_field
            @rule_details.conditions[0].field
          end
          
          # Information about the condition values on the rule
          # @return [Array]
          def condition_values
            @rule_details.conditions[0].values
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
