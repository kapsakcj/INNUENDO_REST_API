from app import db
from flask_restful import Api, Resource, reqparse, abort, fields, marshal_with
from app.models.models import Workflow
from flask_security import current_user, login_required, roles_required
import datetime

# Defining post arguments parser
workflow_post_parser = reqparse.RequestParser()
workflow_post_parser.add_argument('name', dest='name', type=str, required=True,
                                  help="Workflow name")
workflow_post_parser.add_argument('classifier', dest='classifier', type=str,
                                  required=True, help="Workflow classifier")
workflow_post_parser.add_argument('species', dest='species', type=str,
                                  required=True, help="Workflow species")
workflow_post_parser.add_argument('dependency', dest='dependency', type=str,
                                  required=True,
                                  help="Workflow dependency from other "
                                       "workflow")

workflow_list_get_parser = reqparse.RequestParser()
workflow_list_get_parser.add_argument('classifier', dest='classifier',
                                      type=str, required=True,
                                      help="Workflow classifier")
workflow_list_get_parser.add_argument('species', dest='species', type=str,
                                      required=True, help="Workflow species")

workflow_set_availability_put_parser = reqparse.RequestParser()
workflow_set_availability_put_parser.add_argument('identifier',
                                                  dest='identifier', type=str,
                                                  required=True,
                                                  help="Workflow id")
workflow_set_availability_put_parser.add_argument('to_change', dest='to_change',
                                                  type=str, required=True,
                                                  help="Workflow state")

# Defining response fields

workflow_fields = {
    'id': fields.Integer,
    'name': fields.String,
    'timestamp': fields.DateTime,
    'classifier': fields.String,
    'species': fields.String,
    'dependency': fields.String,
    'availability': fields.String
}

workflow_all_fields = {
    'id': fields.Integer,
    'name': fields.String,
    'timestamp': fields.DateTime,
    'classifier': fields.String,
    'species': fields.String,
    'dependency': fields.String,
    'availability': fields.String

}


class WorkflowResource(Resource):
    """
    Class to get information about a given workflow
    """

    @login_required
    @marshal_with(workflow_fields)
    def get(self, id):
        """Get a workflow

        This method can be used to get a workflow by identifier.

        Parameters
        ----------
        id: str
            workflow identifier

        Returns
        -------
        list: list of workflows
        """

        if not current_user.is_authenticated:
            abort(403, message="No permissions")

        workflows = db.session.query(Workflow).filter(Workflow.id == id).first()

        if not workflows:
            abort(404, message="No workflows are available".format(id))
        return workflows, 200


class WorkflowAllResource(Resource):
    """
    Class to get list of workflows
    """

    @login_required
    @marshal_with(workflow_all_fields)
    def get(self):
        """Get all workflows

        This method allows getting all the available workflows on the database

        Returns
        -------
        list: list of workflows
        """

        if not current_user.is_authenticated:
            abort(403, message="No permissions")

        workflows = db.session.query(Workflow).all()

        if not workflows:
            abort(404, message="No workflows are available".format(id))
        return workflows, 200


class WorkflowSetAvailabilityResource(Resource):
    """
    Class to set if workflow is visible or not
    """

    @login_required
    @marshal_with(workflow_all_fields)
    def put(self):
        """Modify visible status

        This method allows modifying the availability status of a workflow.

        Returns
        -------
        workflow object
        """
        if not current_user.is_authenticated:
            abort(403, message="No permissions")

        args = workflow_set_availability_put_parser.parse_args()

        workflow = db.session.query(Workflow)\
            .filter(Workflow.id == args.identifier).first()

        if not workflow:
            abort(404, message="No workflows are available".format(id))

        workflow.availability = args.to_change
        db.session.commit()

        return workflow, 200


class WorkflowListResource(Resource):
    """
    Class to get list of workflows by filter
    """

    @login_required
    @marshal_with(workflow_fields)
    def get(self):
        """Get list of workflows by filter

        Return a list of workflows according to a given classifier and species

        Returns
        -------
        workflow object
        """

        args = workflow_list_get_parser.parse_args()

        if not current_user.is_authenticated:
            abort(403, message="No permissions")
        workflow = db.session.query(Workflow)\
            .filter(Workflow.classifier == args.classifier,
                    Workflow.species == args.species).all()

        if not workflow:
            abort(404, message="No workflows are available".format(id))

        return workflow, 200

    @login_required
    @marshal_with(workflow_fields)
    def post(self):
        """Add workflow

        This method adds a workflow to the database. Requires a name,
        classifier, species and dependency.

        Returns
        -------
        list: workflow list
        """

        args = workflow_post_parser.parse_args()

        if not current_user.is_authenticated:
            abort(403, message="No permissions to POST")

        workflow = Workflow(classifier=args.classifier, name=args.name,
                            timestamp=datetime.datetime.utcnow(),
                            species=args.species, dependency=args.dependency)

        if not workflow:
            abort(404, message="An error as occurried")

        db.session.add(workflow)
        db.session.commit()

        return workflow, 201
