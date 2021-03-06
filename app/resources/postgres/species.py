from app import db
from flask_restful import Resource, reqparse, abort, fields, marshal_with

from app.models.models import Specie

from app.app_configuration import database_correspondece

from flask_security import current_user, login_required

# Defining post arguments parser
specie_post_parser = reqparse.RequestParser()
specie_post_parser.add_argument('name', dest='name', type=str, required=True,
                                help="Species name")

# Defining response fields

species_fields = {
    'id': fields.Integer,
    'name': fields.String
}


class SpecieListResource(Resource):
    """
    Class to get information about the species available
    """

    # @login_required
    @marshal_with(species_fields)
    def get(self):
        """Get species

        Get the available species

        Returns
        -------
        list of species
        """

        species = db.session.query(Specie).all()
        if not species:
            abort(404, message="No species available")
        return species, 200

    @login_required
    @marshal_with(species_fields)
    def post(self):
        """Add specie

        Add a given specie. Requires the species name

        Returns
        -------
        new specie
        """

        args = specie_post_parser.parse_args()
        if not current_user.is_authenticated:
            abort(403, message="No permissions to POST")
        specie = Specie(name=args.name)
        if not specie:
            abort(404, message="An error as occurried")
        db.session.add(specie)
        db.session.commit()
        return specie, 201


class SpeciesSchemaVersions(Resource):

    def get(self):
        """Get species

        Get the available schema versions for all species

        Returns
        -------
        list of versions
        """
        species_name = []
        species_list = []

        for specie in database_correspondece:
            species_name.append(specie)
            species_list.append(database_correspondece[specie])

        versionsdict = {}

        for i, x in enumerate(species_list):
            versions = []
            for value in db.session.query(x).distinct(x.version):
                versions.append(value.version)
            versionsdict[species_name[i]] = versions

        return versionsdict, 200
