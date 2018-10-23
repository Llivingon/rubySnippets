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
          # @raise [RuntimeError] if albs.nil?
          # @raise [RuntimeError] if albs.length == 0
          # @raise [RuntimeError] if albs.length > 1
          def initialize(alb_arn, instance = nil)
            check_init_arg(
              'alb_arn',
              'ElasticLoadBalancingV2::LoadBalancer',
              alb_arn
            )
            @alb_arn = alb_arn
            get_instance instance
            get_alb alb_arn
            get_alb_target_group alb_arn
            get_alb_listener alb_arn
            get_alb_attributes alb_arn
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

          # Information about the listener port on the load balancer
          # @return [String]
          def listener_port
            @alb_listener_details.port
          end

          # Information about the listener protocol on the load balancer
          # @return [String]
          def listener_protocol
            @alb_listener_details.protocol
          end          
          
           # Information about the listener ssl_policy on the load balancer
          # @return [String]
          def listener_ssl_policy
            @alb_listener_details.ssl_policy
          end 

          # Information about the alb attributes on the load balancer
          # @return [Array of Hash]
          def alb_attributes
            @alb_attributes
          end 
                    
          # Information about the health checks conducted on the load balancer
          # @return [Hash]
          def target_health_check
            @alb_tgs
          end
          
          private

          # @private
          def get_alb(arn)
            albs = @aws.describe_load_balancers(
              load_balancer_arns: [arn]
            ).load_balancers
            check_length 'load balancers', albs
            @alb = albs[0]
          end

          # @private
          def get_alb_target_group(arn)
            alb_tgs = @aws.describe_target_groups(
              load_balancer_arn: arn
            ).target_groups
            @alb_tgs = alb_tgs
          end

          # @private
          def get_alb_listener(arn)
            alb_listener_details = @aws.describe_listeners(
              load_balancer_arn: arn
            ).listeners
            check_length 'alb listeners', alb_listener_details
            @alb_listener_details = alb_listener_details
          end

          # @private
          def get_alb_attributes(arn)
            alb_attributes = @aws.describe_load_balancer_attributes(
              load_balancer_arn: arn
            ).attributes
            @alb_attributes = alb_attributes
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
