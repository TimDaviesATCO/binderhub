#!/usr/bin/env python3
""" file: source_aws_credentials.py
    author: Jess Robertson, CSRIO Minerals

    description: Export your credentials from ~/.aws/credentials into the current shell
"""

import logging
import os
import re
import yaml

logger = logging.getLogger('cluster-config')
logger.setLevel('INFO')

## CREDENTIALS
def get_credentials(profile=None):
    """ Get AWS credentials from the credentials file

        Parameters:
            profile - the AWS profile to use. Optional, if
                None defaults to 'default'.

        Returns:
            a dict containing the AWS credentials
    """
    # Get credentials
    logging.info("Parsing ~/.aws/credentials for profiles")
    profile_pattern = re.compile('(?<=\[)[^\[\]]+')
    credsfile = os.path.expanduser('~/.aws/credentials')
    with open(credsfile, 'r') as stream:
        all_creds, current_name = {}, None
        for line in stream:
            ismatch = profile_pattern.search(line)
            if ismatch:
                current_name = ismatch.group(0)
                all_creds[current_name] = {}
            elif current_name is None:
                raise ValueError('Malformed ~/.aws/config file')
            elif line.strip() == '':
                continue
            else:
                key, value = tuple(line.split('='))
                all_creds[current_name][key.strip()] = value.strip()

    # Get the credentials we care about
    profile = profile or 'default'
    try:
        return {
            'AWS_ACCESS_KEY_ID': all_creds[profile]['aws_access_key_id'],
            'AWS_SECRET_ACCESS_KEY': all_creds[profile]['aws_secret_access_key']
        }
    except KeyError:
        msg = 'Unknown profile {0}, available profiles are {1}'
        raise ValueError(msg.format(profile, all_creds.keys()))

def main():
    # Get AWS credentials
    creds = get_credentials(profile=os.environ.get('AWS_PROFILE', None))
    print('\n'.join(f'export {k}="{v}"' for k, v in creds.items()))

    # Get conda environment
    # with open(os.path.join(os.path.dirname(__file__), 'environment.yml'), 'r') as src:
    #     conda_env = yaml.load(src)['name']
    # print(f'source activate {conda_env}')

if __name__ == '__main__':
    main()