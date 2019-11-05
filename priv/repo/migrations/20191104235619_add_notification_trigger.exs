defmodule OpApi.Repo.Migrations.AddNotificationTrigger do
  use Ecto.Migration

  @function_name "notify_op_created"
  @event_name "new_op"
  @trigger_name "op_created"
  @table_name "ops"

  def up do
    execute("""
      CREATE OR REPLACE FUNCTION #{@function_name}()
      RETURNS trigger AS $$
      BEGIN
        PERFORM pg_notify(
          '#{@event_name}',
          json_build_object(
            'id', NEW.txid,
            'type', TG_OP,
            'data', row_to_json(NEW)
          )::text
        );
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    """)

    execute("DROP TRIGGER IF EXISTS #{@trigger_name} ON #{@table_name}")
    execute("""
      CREATE TRIGGER #{@trigger_name}
      AFTER INSERT OR UPDATE
      ON #{@table_name}
      FOR EACH ROW
      WHEN (NEW.ref IS NULL)
      EXECUTE PROCEDURE #{@function_name}()
    """)
  end

  def down do
    execute("DROP FUNCTION IF EXISTS #{@function_name} CASCADE")
    execute("DROP TRIGGER IF EXISTS #{@trigger_name} ON #{@table_name}")
  end
end
