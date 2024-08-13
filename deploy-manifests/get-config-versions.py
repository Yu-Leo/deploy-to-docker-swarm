import os
import sys

import yaml
import hashlib

TYPE = 'configs'


def get_environment_variables(dc_file_content: dict, working_dir: str) -> dict:
    result = {}

    if TYPE not in dc_file_content:
        return result

    for _, data in dc_file_content[TYPE].items():
        name = data.get('name')
        if not name or not (name.startswith('${') and name.endswith("}")):
            continue

        path_to_file = data.get('file')
        if not path_to_file:
            continue

        path_to_file = os.path.join(working_dir, path_to_file)

        if not os.path.exists(path_to_file):
            continue

        with open(path_to_file, 'rb') as file:
            version = hashlib.md5(file.read()).hexdigest()

        key = name[2:-1]
        result[key] = f"{key}_{version}".lower()
    return result


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('NO MODE')
        exit(1)

    if sys.argv[1] == "--prod":
        dc_file_name = 'docker-compose.prod.yaml'
    elif sys.argv[1] == "--dev":
        dc_file_name = 'docker-compose.dev.yaml'
    else:
        print('UNKNOWN MODE')
        exit(1)

    with open(dc_file_name) as stack_yml:
        cfg = yaml.safe_load(stack_yml.read())

    variables = get_environment_variables(cfg, '.')

    for variable_name, variable_value in variables.items():
        print(f'{variable_name}={variable_value}')
