from app import app, db
from flask_restful import Api, Resource, reqparse, abort, fields, marshal_with #filters data according to some fields
from flask_security import current_user
from flask import jsonify, send_from_directory

from flask_security import current_user, login_required, roles_required, auth_token_required
import datetime

'''
File resources:
	- Get template for strain batch submission
'''

class TemplateResource(Resource):

	@login_required
	def get(self):
		templates_folder = 'app/static/file_templates/'
		return send_from_directory(directory=templates_folder, filename="template_strain_batch_submission.tab")
