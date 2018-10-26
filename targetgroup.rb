module Serverspec
  module Type
    module AWS
      # The ElasticLoadBalancing module contains the ElasticLoadBalancingV2 API
      # resources
      module ElasticLoadBalancingV2
        # The LoadBalancer class exposes the ElasticLoadBalancing::LoadBalancerTGHealth
        # resources
        class LoadBalancerRule < Base
          # AWS SDK for Ruby v2 Aws::ElasticLoadBalancing::LoadBalancerTGHealth wrapper
          # for initializing a LoadBalancerRule resource
          # @param alb_name [String] The arn of the Rule
          # rubocop:disable LineLength
          # @param instance [Class] Aws::ElasticLoadBalancing::LoadBalancerTGHealth instance
          # rubocop:enable LineLength
          # @raise [RuntimeError] if albs.nil?
          # @raise [RuntimeError] if albs.length == 0
          # @raise [RuntimeError] if albs.length > 1
          def initialize(target_group_arn, instance = nil)
            check_init_arg(
              'target_group_arn',
              'ElasticLoadBalancingV2::LoadBalancerTGHealth',
              target_group_arn
            )
            @target_group_arn = target_group_arn
            get_instance instance
            get_target_group_health target_group_arn
          end

          # Indicates whether target_health is_healthy
          # @return [Array]
          def target_group_details
            @target_group_details
          end      

          private

          # @private
          def describe_target_health(target_group_arn)
            target_group_details = @aws.describe_target_health(
              target_group_arn: target_group_arn
            ).target_health_descriptions
            @target_group_details = target_health_descriptions
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
