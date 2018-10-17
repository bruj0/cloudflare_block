connection: "bigquery_camiliame"

# include all the views
include: "*.view"

datagroup: camilia_looker_default_datagroup {
#   sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: camilia_looker_default_datagroup

explore: camiliame_logs {

  join: countries {
    relationship: one_to_one
    sql_on: ${camiliame_logs.client_country_code} = ${countries.country_code} ;;
  }

  join: events_per_second {
    type: left_outer
    relationship: many_to_one
    sql_on: ${camiliame_logs.edge_start_timestamp_second} = ${events_per_second.time_seconds_key};;
  }

  join: current_second_stats {
    type: cross
    relationship: one_to_one
 #   sql_on: ${camiliame_logs.edge_start_timestamp_second} = ${current_second_stats.current_second} ;;
  }

  join: origin_response_time_quantiles {
    type: left_outer
    relationship: one_to_one
    sql_on: ${camiliame_logs.edge_start_timestamp_second} = ${origin_response_time_quantiles.EdgeStartTimestamp_second} ;;
  }
}

explore: dynamic_requests_summary {}

explore: static_requests_summary {}

explore: events_per_second {}

explore: current_second_stats {}
