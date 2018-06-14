{ stdenv, python3, callPackage, git }:

let
	inherit (python3.pkgs) buildPythonApplication buildPythonPackage fetchPypi;
	progress = (callPackage ../progress/default.nix { });
	python-gitlab = (callPackage ../python-gitlab/default.nix { });
	gogs_client = (callPackage ../gogs_client/default.nix { });
	pybitbucket_fork = (callPackage ../pybitbucket_fork/default.nix { });
	gitdb2 = (callPackage ../gitdb2/default.nix { });
in
	buildPythonApplication rec {
		pname = "git-repo";
		version = "1.10.3";
		name = "${pname}-${version}";

		src = fetchPypi {
			inherit pname version;
			sha256 = "5a1bbc284e270f810136e3356a57d4624575859db897e261fef832fa6b5d6bb4";
		};

		buildInputs = [ git ];

		propagatedBuildInputs = with python3.pkgs; [
			docopt progress dateutil lxml

			python-gitlab gogs_client pybitbucket_fork

			(GitPython.overrideAttrs (oldAttrs: rec {
				pname = "GitPython";
				version = "2.1.10";
				name = "${pname}-${version}";

				src = fetchPypi {
					inherit pname version;
					sha256 = "b60b045cf64a321e5b620debb49890099fa6c7be6dfb7fb249027e5d34227301";
				};

				propagatedBuildInputs = [ gitdb2 ];
			}))

			(buildPythonPackage rec {
				pname = "github3.py";
				version = "0.9.6";
				name = "${pname}-${version}";

        doCheck = false;

				src = fetchPypi {
					inherit pname version;
					sha256 = "b831db85d7ff4a99d6f4e8368918095afeea10f0ec50798f9a937c830ab41dc5";
				};

        propagatedBuildInputs = with python3.pkgs; [
          requests

          (buildPythonPackage rec {
            pname = "uritemplate.py";
            version = "2.0.0";
            name = "${pname}-${version}";

            src = fetchPypi {
              inherit pname version;
              sha256 = "f2ddd797c3d0630ed23ad19a4dc9e3c570a4f1e0f5470f502c2a3546d7159adf";
            };
          })
        ];
			})
		];

		meta = with stdenv.lib; {
			inherit (src.meta) homepage;
			description = "Git-Repo: CLI utility to manage git services from your workspace";
			license = licenses.gpl2;
			platforms = platforms.all;
			maintainers = with maintainers; [ rummik ];
		};
	}
