# module ActiveRecord
#   module ConnectionAdapters
#     class AbstractMysqlAdapter
#       def columns(table_name)#:nodoc:
#         sql = "SHOW FULL FIELDS FROM #{quote_table_name(table_name)}"
#         execute_and_free(sql, 'SCHEMA') do |result|
#           each_hash(result).map do |field|
#             field_name = set_field_encoding(field[:Field])
#             sql_type = field[:Type]
#             cast_type = lookup_cast_type(sql_type)
#             new_column(field_name, field[:Default], cast_type, sql_type, field[:Null] == "YES", field[:Collation], field[:Extra])
#           end
#         end
#       end
#     end
#   end
# end

######################################################################################################################################################
# 170807 20:23:46    55 Connect root@localhost as anonymous on rails_study
#        55 Query SET NAMES utf8,  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483, @@SESSION.sql_mode = 'STRICT_ALL_TABLES'
#        55 Query SHOW TABLES LIKE 'schema_migrations'
#        55 Query SELECT `schema_migrations`.* FROM `schema_migrations`
#        55 Query SHOW FULL FIELDS FROM `schema_migrations`
#        55 Query SHOW TABLES
#        55 Query SHOW CREATE TABLE `articles`
#        55 Query SHOW FULL FIELDS FROM `articles`
#        55 Query SELECT  `articles`.* FROM `articles` WHERE `articles`.`id` = 1 LIMIT 1
#        55 Query SHOW FULL FIELDS FROM `contents`
#        55 Query SELECT `contents`.* FROM `contents` WHERE `contents`.`article_id` IN (1)
#        55 Query SHOW CREATE TABLE `contents`

          ####
          ####
          ####
      ############
       ##########
        ########
         ######
          ####
           ##

# 170807 20:24:57    55 Query SELECT  `articles`.* FROM `articles` WHERE `articles`.`id` = 1 LIMIT 1
#        55 Query SELECT `contents`.* FROM `contents` WHERE `contents`.`article_id` IN (1)
######################################################################################################################################################

module ActiveRecord
  module Querying
    def find_by_sql(sql, binds = [])
      result_set = connection.select_all(sanitize_sql(sql), "#{name} Load", binds)
      column_types = result_set.column_types.dup
      # columns_hash.each_key { |k| column_types.delete k }
      message_bus = ActiveSupport::Notifications.instrumenter

      payload = {
        record_count: result_set.length,
        class_name: name
      }

      message_bus.instrument('instantiation.active_record', payload) do
        result_set.map { |record| instantiate(record, column_types) }
      end
    end
  end
end

module Arel
  module Visitors
    class ToSql
      def column_for attr
        return unless attr
        name    = attr.name.to_s
        table   = attr.relation.table_name

        return nil unless table_exists? table

        # column_cache(table)[name]
      end
    end
  end
end

module ActiveRecord
  module Persistence
    module ClassMethods
      def instantiate(attributes, column_types = {})
        klass = discriminate_class_for_record(attributes)
        attributes = klass.attributes_builder.build_from_database(attributes, column_types)
        klass.allocate.init_with('attributes' => attributes, 'new_record' => false)
      end
    end
  end
end
