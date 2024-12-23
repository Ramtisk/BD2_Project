class MongoDBRouter:
    def db_for_read(self, model, **hints):
        """Point all read operations on AppLogs to MongoDB."""
        if model._meta.app_label == 'mongo_app':
            return 'mongodb'
        return 'default'

    def db_for_write(self, model, **hints):
        """Point all write operations on AppLogs to MongoDB."""
        if model._meta.app_label == 'mongo_app':
            return 'mongodb'
        return 'default'

    def allow_relation(self, obj1, obj2, **hints):
        """Allow relations if both models are in PostgreSQL."""
        db_list = ('default', 'mongodb')
        if obj1._state.db in db_list and obj2._state.db in db_list:
            return True
        return None

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        if app_label == 'mongo_app':
            return db == 'mongodb'
        return db == 'default'
