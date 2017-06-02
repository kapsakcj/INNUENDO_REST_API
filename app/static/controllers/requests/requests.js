function Requests(CURRENT_PROJECT_ID, CURRENT_PROJECT, $http) {

	return {

		//////////////// Protocols Requests /////////////////////////////////////////
		download_accession: function(username, accession_numbers, callback){
			console.log(accession_numbers);
			req = {
		        url:'api/v1.0/downloads/',
		        method:'POST',
		        data: { accession_numbers: accession_numbers }
		    }

		    $http(req).then(function(response){
		    	console.log(response);
		    	callback(response, accession_numbers);
		    }, function(response){
		    	console.log(response);
		    	callback(response, accession_numbers);
		    });
		},

		check_download_accession_status: function(file_name, accession_numbers, callback){
			console.log(file_name);
			req = {
		        url:'api/v1.0/downloads/',
		        method:'GET',
		        params: { accession_numbers: file_name }
		    }

		    $http(req).then(function(response){
		    	console.log(response);
		    	callback(response, accession_numbers);
		    }, function(response){
		    	console.log(response);
		    	callback(response, accession_numbers);
		    });
		},
		create_protocol: function(protocol_object, callback){
			req = {
		        url:'api/v1.0/protocols/',
		        method:'POST',
		        headers: {'Content-Type': 'application/json'},
		        data: { steps: protocol_object, name: protocol_object.name}
		    }

		    $http(req).then(function(response){
		    	callback(response);
		    }, function(response){
		    	callback(response);
		    });
		},
		get_protocols_of_type: function(selectedType, callback){
			req = {
		        url:'api/v1.0/protocols/',
		        method:'GET',
		        params: { type: selectedType }
		    }

		    $http(req).then(function(response){
		    	callback(response);
		    }, function(response){
		    	callback(response);
		    });
		},
		get_protocols_by_ids: function(ids, callback){
			req = {
		        url:'api/v1.0/protocols/ids',
		        method:'GET',
		        params: { protocol_ids: ids }
		    }

		    $http(req).then(function(response){
		    	callback(response);
		    }, function(response){
		    	callback(response);
		    });
		},
		//////////////// Workflows Requests /////////////////////////////////////////
		add_workflow: function(callback){

			console.log($('#new_workflow_form').serialize() + "&classifier=" + $( "#select_classifier option:selected" ).text());
			req = {
		        url:'api/v1.0/workflows/',
		        method:'POST',
		        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
		        data: $('#new_workflow_form').serialize() + "&classifier=" + $( "#select_classifier option:selected" ).text()
		    }

		    $http(req).then(function(response){
		    	console.log(response);
		    	callback(response);
		    }, function(response){
		    	console.log(response);
		    	callback(response);
		    });
		},
		//////////////// Projects Table Requests /////////////////////////////////////////
		get_species_names: function(callback){
			req = {
	            url:'api/v1.0/species/',
	            method:'GET'
	        }

	        $http(req).then(function(response){
	            callback(response);
	        }, function(response){
	        	callback(response);
	        });
		},

		get_species_projects: function(species_id, is_others, callback){

			//Get user projects for specie 1
			if(is_others){
				req = {
	                url:'api/v1.0/projects/species/' + species_id,
	                method:'GET',
	                params: { get_others: true }
	            }
			}
			else{
				req = {
	                url:'api/v1.0/projects/species/' + species_id,
	                method:'GET'
	            }
			}

	        $http(req).then(function(response){
	        	callback(response);
	      
	        }, function(response){
	        	callback(response);
	        });
		},
		add_project_to_database: function(callback){

			req = {
		        url:'api/v1.0/projects/',
		        method:'POST',
		        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
		        data: $('#new_project_form').serialize()
		    }

		    $http(req).then(function(response){
		    	callback(response);
		    }, function(response){
		        callback(response);
		    });	
		},
		delete_project_from_database: function(project_id, callback){

			req = {
	            url:'api/v1.0/projects/' + project_id,
	            method:'DELETE'
	        }

	        $http(req).then(function(response){
	            callback(response);
	        }, function(response){
	        	callback(response);
	        });
		},
		load_project: function(project_id, callback){

			req = {
	            url:'api/v1.0/projects/' + project_id,
	            method:'GET'
	        }

	        $http(req).then(function(response){
	            callback(response);
	        }, function(response){
	        	callback(response);
	        });
		},
		//////////////// Reports Requests /////////////////////////////////////////
		get_user_reports: function(callback){

		    req = {
		        url: 'api/v1.0/reports/', //Defined at utils.js
		        method:'GET'
		    }

		    $http(req).then(function(response){
		    	callback(response);
	        },function(response){
	            callback(response);
		    });

		},
		get_project_reports: function(project_id, pipelines_to_check, callback){

		    req = {
		        url: 'api/v1.0/reports/project', //Defined at utils.js
		        method:'GET',
		        params:{'project_id': project_id, 'pipelines_to_check':pipelines_to_check}
		    }

		    $http(req).then(function(response){
		    	callback(response);
	        },function(response){
	            callback(response);
		    });

		},
		get_multiple_user_reports: function(job_ids, callback){
			console.log('IDS', job_ids);
		    req = {
		        url: 'api/v1.0/reports/', //Defined at utils.js
		        method:'GET',
		        params: {
		        	job_ids:job_ids.toString()
		        }
		    }

		    $http(req).then(function(response){
		    	callback(response);
	        },function(response){
	            callback(response);
		    });

		},
		save_reports: function(job_ids, strain_names, CURRENT_SPECIES_ID, callback){

			console.log(strain_names,job_ids);

		    req = {
		        url: 'api/v1.0/reports/combined', //Defined at utils.js
		        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
		        method:'POST',
		        data: $('#save_report_form').serialize() + '&job_ids=' + job_ids + '&strain_ids=' + strain_names +'&species_id='+ CURRENT_SPECIES_ID
		    }

		    $http(req).then(function(response){
		    	callback(response);
	        },function(response){
	            callback(response);
		    });

		},
		get_saved_user_reports: function(CURRENT_SPECIES_ID, callback){

		    req = {
		        url: 'api/v1.0/reports/combined', //Defined at utils.js
		        method:'GET',
		        params:{"species_id": CURRENT_SPECIES_ID}
		    }

		    $http(req).then(function(response){
		    	console.log(response);
		    	callback(response);
	        },function(response){
	        	console.log(response);
	            callback(response);
		    });

		},
		delete_combined_report: function(report_name, callback){

		    req = {
		        url: 'api/v1.0/reports/combined', //Defined at utils.js
		        method:'DELETE',
		        params: {
		        	"report_name": report_name
		        }
		    }

		    $http(req).then(function(response){
		    	callback(response);
	        },function(response){
	            callback(response);
		    });

		},
		get_saved_report: function(callback){

		    req = {
		        url: 'api/v1.0/reports/combined/show', //Defined at utils.js
		        method:'GET',
		    }

		    $http(req).then(function(response){
		    	callback(response);
	        },function(response){
	            callback(response);
		    });

		},
		//////////////// Single Project Requests /////////////////////////////////////////
		get_workflows: function(classifier, callback){

		    req = {
		        url: 'api/v1.0/workflows/', //Defined at utils.js
		        method:'GET',
		        params:{"classifier": classifier}
		    }

		    $http(req).then(function(response){
		    	console.log(response);
		    	callback(response);
	        },function(response){
	        	console.log(response);
	            callback(response);
		    });

		},
		add_pipeline: function(pipelineformID, callback){

		    req = {
		        url: CURRENT_PROJECT.pipelines,
		        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
		        method:'POST',
		        data:$('#' + pipelineformID).serialize()
		    }

		    $http(req).then(function(response){
		      		callback(response);
		        },
		        function(response){
		            callback(response);
		    });	

		},
		get_strains: function(CURRENT_SPECIES_ID, callback){


		    req = {
		        url: 'api/v1.0/strains/',
		        method:'GET',
		        params:
		        {
		        	speciesID: CURRENT_SPECIES_ID
		        }
		    }

		    $http(req).then(function(response){
		            callback(response);
		        },
		        function(response){
		            callback(response);
		    });

		},
		get_strain_by_name: function(strain_name, callback){


		    req = {
		        url: 'api/v1.0/strains/' + strain_name,
		        method:'GET'
		    }

		    $http(req).then(function(response){
		            callback(response);
		        },
		        function(response){
		            callback(response);
		    });

		},
		get_applied_pipelines: function(strain_id, project_id, callback){
			console.log(strain_id);
			if (strain_id == null){
				req = {
			        url: 'api/v1.0/projects/'+project_id+'/pipelines/',
			        method:'GET'
			    }
			}
			else{
				req = {
			        url: 'api/v1.0/projects/'+project_id+'/pipelines/',
			        method:'GET',
			        params:{ strain_id_all:strain_id}
			    }
			}

		    $http(req).then(function(response){
		    	console.log(response);
		        callback(response, strain_id);
	        },
	        function(response){
	        	console.log(response);
	            callback(response, strain_id);
		    });
		},
		get_public_strains_applied_pipelines: function(callback){

		    req = {
		        url: 'api/v1.0/projects/'+CURRENT_PROJECT_ID+'/pipelines/',
		        method:'GET',
		        params:{all:true}
		    }

		    $http(req).then(function(response){
		        callback(response);
	        },
	        function(response){
	            callback(response);
		    });
		},
		remove_pipeline_from_project: function(strain_id, tag_remove, callback){

		    req = {
		        url: 'api/v1.0/projects/'+CURRENT_PROJECT_ID+'/pipelines/',
		        method:'DELETE',
		        params: {
		        	"strain_id": strain_id,
		        	tag_remove: tag_remove
		        }
		    }

		    $http(req).then(function(response){
		        callback(response);
	        },
	        function(response){
	            callback(response);
		    });
		},
		change_pipeline_from_project: function(strain_id, tag_remove, pipeline_to_use, callback){

		    req = {
		        url: 'api/v1.0/projects/'+CURRENT_PROJECT_ID+'/pipelines/',
		        method:'PUT',
		        params: {
		        	"strain_id": strain_id,
		        	tag_remove: tag_remove
		        }
		    }

		    $http(req).then(function(response){
		        callback(response, strain_id, pipeline_to_use);
	        },
	        function(response){
	            callback(response, strain_id, pipeline_to_use);
		    });
		},
		get_uploaded_files: function(callback){

		    req = {
		        url: 'api/v1.0/uploads/',
		        method:'GET'
		    }

		    $http(req).then(function(response){
		            callback(response);
		        },
		        function(response){
		            callback(response);
		    });
		},
		get_project_strains: function(callback){

			req = {
		        url: 'api/v1.0/projects/'+CURRENT_PROJECT_ID+'/strains/',
		        method:'GET'
		    }

		    $http(req).then(function(response){
		            callback(response);
		        },
		        function(response){
		            callback(response);
		    });
		},
		get_project_strains_2: function(strain_id, is_there, callback){

			req = {
		        url: 'api/v1.0/projects/'+CURRENT_PROJECT_ID+'/strains/',
		        method:'GET'
		    }

		    $http(req).then(function(response){
		            callback(response, strain_id, is_there);
		        },
		        function(response){
		            callback(response, strain_id, is_there);
		    });
		},
		add_strain_to_project: function(strain_name, callback){

		    req = {
		        url: 'api/v1.0/projects/'+CURRENT_PROJECT_ID+'/strains/',
		        method:'PUT',
		        data: {
		            "strainID": strain_name.trim()
		        }
		    }

		    $http(req).then(function(response){  
		    		console.log(response);          
		            callback(response);
		        },
		        function(response){
		        	console.log(response);  
		            callback(response);
		    });
		},
		add_new_strain: function(callback){

			console.log($('#new_strain_form').find("select, input, textarea").serialize());
		    
		    req = {
		        url: 'api/v1.0/strains/',
		        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
		        method:'POST',
		        data: $('#new_strain_form').find("select, input, textarea").serialize()
		    }

		    $http(req).then(function(response){
		            callback(response);
		        },
		        function(response){
		            callback(response);
		    });

		},

		remove_strain_from_project: function(strain_name, callback){

			req = {
	            url: 'api/v1.0/projects/'+CURRENT_PROJECT_ID+'/strains/',
	            method:'DELETE',
	            params: {
	                "strainID": strain_name
	            }
	        }

	        $http(req).then(function(response){
	                callback(response);
	            },
	            function(response){
	                callback(response);
	        });
		},
		check_if_pipeline_exists: function(strain_id, callback){
			req = {
	            url: 'api/v1.0/projects/'+CURRENT_PROJECT_ID+'/pipelines/',
	            method:'GET',
	            params: {
	                strain_id_all: strain_id,
	                parent_project_id: CURRENT_PROJECT_ID
	            }
	        }
	        $http(req).then(function(response){
	               callback(response, strain_id);
	            },
	            function(response){
	               callback(response, strain_id);
	        });
		},
		add_pipeline: function(strain_id, parent_pipeline_id, parent_project_id, callback){

	        req = {
	            url: 'api/v1.0/projects/'+CURRENT_PROJECT_ID+'/pipelines/',
	            method:'POST',
	            data: {
	                strain_id: strain_id,
	                parent_pipeline_id:parent_pipeline_id,
	                parent_project_id:parent_project_id
	            }
	        }

	        $http(req).then(function(response){
	               callback(response);
	            },
	            function(response){
	               callback(response);
	        });
		},
		run_job: function(strain_id, protocol_ids, pipeline_id, process_id, strain_name, callback){

			console.log(protocol_ids, pipeline_id, process_id);

		    req = {
		        url: 'api/v1.0/jobs/',
		        method:'POST',
		        data: {
		        	strain_id: strain_id,
		        	protocol_ids: protocol_ids,
		        	project_id: CURRENT_PROJECT_ID,
		        	pipeline_id: pipeline_id,
		        	process_id: process_id.join()
		    	}
		    }

		    $http(req).then(function(response){
		            callback(response, strain_name);
		        },
		        function(response){
		            callback(response, strain_name);
		    });

		},
		get_job_status: function(job_id, procedure_name, sample_name, pipeline_id, process_position, project_id, process_id, callback){
		    //console.log(project_id);
		    req = {
		        url: 'api/v1.0/jobs/',
		        method:'GET',
		        params: {
		        	job_id: job_id,
		        	procedure_name:procedure_name,
		        	sample_name:sample_name,
		        	pipeline_id:pipeline_id,
		        	process_position:process_position,
		        	project_id:project_id,
		        	process_id:process_id
		    	}
		    }

		    $http(req).then(function(response){
		            callback(response);
		        },
		        function(response){
		            callback(response);
		    });

		},

		//////////////////////////////// GET FILES ////////////////////////////////////////
		get_user_files: function(callback){

			req = {
		        url: 'api/v1.0/files/',
		        method:'GET'
		    }

		    $http(req).then(function(response){
		            callback(response);
		        },
		        function(response){
		            callback(response);
		    });
		},

		download_file: function(path, callback){

			url = CURRENT_JOBS_ROOT + 'results/download/?file_path=' + encodeURI(path);
			console.log(url);

			var link = document.createElement("a");
		    link.download = path.split('/').slice(-1)[0];
		    link.href = url;
		    link.click();
		    callback();
			
		},

		//////////////////////////// SEND TO PHYLOVIZ ////////////////////////////////////////
		/*send_to_phyloviz: function(profile_data, metadata, callback){
			
			var headers_profile = JSON.stringify(profile_data[0]);
			var body_profile = JSON.stringify(profile_data[1]);

			var headers_metadata = JSON.stringify(metadata[0]);
			var body_metadata = JSON.stringify(metadata[1]);

			console.log('ONREQUEST');

			req = {
		        url: 'api/v1.0/phyloviz/',
		        method:'POST',
		        data: {
		        	headers_profile: headers_profile,
		        	body_profile: body_profile,
		        	headers_metadata: headers_metadata,
		        	body_metadata: body_metadata,
		        	dataset_name: $('#modal_phyloviz_dataset_name').text(),
		        	dataset_description: $('#modal_phyloviz_dataset_description').text()
		    	}
		    }

		    $http(req).then(function(response){
		            callback(response);
		        },
		        function(response){
		            callback(response);
		    });
		}*/

		send_to_phyloviz: function(job_ids, callback){
			
			console.log('ONREQUEST');

			req = {
		        url: 'api/v1.0/phyloviz/',
		        method:'POST',
		        data: {
		        	job_ids: job_ids.join(","),
		        	dataset_name: $('#modal_phyloviz_dataset_name').text(),
		        	dataset_description: $('#modal_phyloviz_dataset_description').text()
		    	}
		    }

		    $http(req).then(function(response){
		            callback(response);
		        },
		        function(response){
		            callback(response);
		    });
		}
	}
}