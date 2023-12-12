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
