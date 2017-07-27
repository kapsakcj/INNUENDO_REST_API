from app import db
import random
import os
import string
import json
from app.models.models import Ecoli, Yersinia, Campylobacter, Salmonella, Core_Schemas, Report, Strain, Tree

import subprocess
from subprocess import call

'''
Fast-MLST (https://github.com/aplf/fast-mlst) functions:
	- update index files used for the rapid search of the closest profiles
	- Search for closest profiles. Gives a list of the closest profiles with a length of max_closest
'''


def get_closest_profiles(profile_query_file_path, index_path, max_closest):

	file_name = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(8))
	myinput = open(profile_query_file_path)

	command = './dependencies/fast-mlst/src/main -i '+index_path+' -q '+str(max_closest);
	command = command.split(' ')
	print command

	proc = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=myinput)
	stdout, stderr = proc.communicate()

	print stdout, stderr

	entries = stdout.split("\n")
	del entries[-1]

	return entries

def update_index(profile_query_file_path, index_path):

	file_name = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(8))
	myinput = open(profile_query_file_path)


	command = './dependencies/fast-mlst/src/main -i '+index_path+' -b';
	command = command.split(' ')
	print command

	proc = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=myinput)
	stdout, stderr = proc.communicate()

	print stdout, stderr

	return "DONE"


