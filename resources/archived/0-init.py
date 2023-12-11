from bindings import bindings
from IPython.core.getipython import get_ipython

################################################################
# Initialize ServiceBinding abstraction object
################################################################
SERVICEBINDING = None
SERVICEBINDING = bindings.from_service_binding_root()


################################################################
# Prepend cell to notebooks
################################################################
def create_new_cell(contents):
    shell = get_ipython()
    payload = dict(
        source='set_next_input',
        text=contents,
        replace=False,
    )
    shell.payload_manager.write_payload(payload, single=False)


create_new_cell("""
###############################################################
# Check if any service bindings have been initialized
###############################################################
# bindings.check_service_bindings_exist()

###############################################################
# Get the ServiceBinding object associated with your service
###############################################################
# my_binding = SERVICEBINDING.find(b, "bkstg-xxx-name-of-service-binding")

###############################################################
# Get a list of property keys associated with this binding
# Example: provider, username, host, port, uri, etc
###############################################################
# [f.name for f in os.scandir(my_binding._root) if not f.name.startswith('.')]

###############################################################
# Connect to your service (using the keys listed above)
###############################################################
# Example: For Tanzu Postgres/Greenplum:
# import sqlalchemy
# my_binding_uri_property = my_binding.get(URI_KEY_LISTED_ABOVE)
# conn = sqlalchemy.create_engine(my_binding_uri_property)
# %load_ext sql
# %sql $conn.url
""")
