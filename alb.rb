module Serverspec
  module Type
    module AWS
      # The ElasticLoadBalancing module contains the ElasticLoadBalancing API
      # resources
      module ElasticLoadBalancingV2
        # The LoadBalancer class exposes the ElasticLoadBalancing::LoadBalancer
        # resources
        class LoadBalancer < Base
          # AWS SDK for Ruby v2 Aws::ElasticLoadBalancing::LoadBalancer wrapper
          # for initializing a LoadBalancer resource
          # @param alb_name [String] The name of the LoadBalancer
          # rubocop:disable LineLength
          # @param instance [Class] Aws::ElasticLoadBalancing::LoadBalancer instance
          # rubocop:enable LineLength
          # @raise [RuntimeError] if elbs.nil?
          # @raise [RuntimeError] if elbs.length == 0
          # @raise [RuntimeError] if elbs.length > 1
          def initialize(alb_arn, instance = nil)
            check_init_arg(
              'alb_arn',
              'ElasticLoadBalancingV2::LoadBalancer',
              alb_arn
            )
            @alb_arn = alb_arn
            get_instance instance
            get_alb alb_arn
          end

          # Returns the string representation of
          # ElasticLoadBalancing::LoadBalancer
          # @return [String]
          def to_s
            "ElasticLoadBalancing LoadBalancer: #{@alb.load_balancer_name}"
          end

          # Indicates whether the scheme is internal
          def internal?
            @alb.scheme == 'internal'
          end

          # Indicates whether the scheme is internet-facing
          def internet_facing?
            @alb.scheme == 'internet-facing'
          end

          # The external DNS name of the load balancer
          # @return [String]
          def dns_name
            @alb.dns_name
          end

          # The Amazon Route 53 hosted zone ID associated with the load balancer
          # @return [String]
          def canonical_hosted_zone_id
            @alb.canonical_hosted_zone_id
          end

          # The ARN of the load balancer
          # @return [String]
          def load_balancer_arn
            @alb.load_balancer_arn
          end

          # The type for the load balancer
          # @return [String]
          def type
            @alb.type
          end

          # The ZoneNames of the Availability Zones for the load balancer
          # @return [Array(Hash)]
          def availability_zones
            zones = []
            @alb.availability_zones.each do |inst|
              zones << inst.zone_name
            end
            zones
          end
          
          # The Ids of Subnets of the load balancer
          # @return [Array(Hash)]
          def subnets
            subnetIds = []
            @alb.availability_zones.each do |inst|
              subnetIds << inst.subnet_id
            end
            subnetIds
          end

          # The ID of the VPC for the load balancer
          # @return [String]
          def vpc_id
            @alb.vpc_id
          end

          # The state for the load balancer 
          # String, one of "active", "provisioning", "active_impaired", "failed"
          # @return [String ]
          def state
            @alb.state.code
          end

          # The security groups for the load balancer. Valid only for load
          # balancers in a VPC
          # @return [Array(String)]
          def security_groups
            @alb.security_groups
          end

          private

          # @private
          def get_alb(arn)
            albs = @aws.describe_load_balancers(
              load_balancer_names: [arn]
            ).load_balancers
            check_length 'load balancers', albs
            @alb = albs[0]
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
