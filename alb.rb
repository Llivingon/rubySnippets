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

          # The ID of the Amazon Route 53 hosted zone name associated with the
          # load balancer
          # @return [String]
          def canonical_hosted_zone_name_id
            @alb.canonical_hosted_zone_name_id
          end

          # The listeners for the load balancer
          # @return [Array(Hash)]
          def listeners
            @alb.listener_descriptions
          end

          # The policies defined for the load balancer
          # @return [Hash]
          def policies
            @alb.policies
          end

          # Information about the back-end servers
          # @return [Array(Hash)]
          def backend_server_descriptions
            @alb.backend_server_descriptions
          end

          # The Availability Zones for the load balancer
          # @return [Array(String)]
          def availability_zones
            @alb.availability_zones
          end

          # The IDs of the subnets for the load balancer
          # @return [Array(String)]
          def subnets
            @alb.subnets
          end

          # The ID of the VPC for the load balancer
          # @return [String]
          def vpc_id
            @alb.vpc_id
          end

          # The IDs of the instances for the load balancer
          # @return [Array(Hash)]
          def instances
            instances = []
            @alb.instances.each do |inst|
              instances << inst.instance_id
            end
            instances
          end

          # Information about the health checks conducted on the load balancer
          # @return [Hash]
          def health_check
            @alb.health_check
          end

          # The security group that you can use as part of your inbound rules
          # for your load balancer's back-end application instances. To only
          # allow traffic from load balancers, add a security group rule to your
          # back end instance that specifies this source security group as the
          # inbound source
          # @return [Hash]
          def source_security_group
            @alb.source_security_group
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
