output "gke" {
    # value       = "[${module.gce_instances[].instance_self_link}]"
    value       = { 
                    "name":         module.gke.name,
                    "cluster_id":   module.gke.cluster_id,
                    "location":     module.gke.location,
                    "type":         module.gke.type,
                    "region":       module.gke.region,
                    "zones":        module.gke.zones
                 }
    #sensitive   = true
}