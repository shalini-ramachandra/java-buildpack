# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright (c) 2013 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'java_buildpack/util/play/pre22'

module JavaBuildpack::Util::Play

  # Encapsulate inspection and modification of Play dist applications up to and including Play 2.1.x.
  class Pre22Dist < Pre22

    protected

    def augment_classpath
      if version.start_with? '2.0'
        @application.additional_libraries.link_to lib_dir
      else
        additional_classpath = @application.additional_libraries.paths.map do |additional_library|
          "$scriptdir/#{additional_library.relative_path_from(root)}"
        end

        update_file start_script, /^classpath=\"(.*)\"$/, "classpath=\"#{additional_classpath.join(':')}:\\1\""
      end
    end

    def java_opts
      @application.java_opts
    end

    def lib_dir
      root + 'lib'
    end

    def root
      @application.glob('*').select { |child| child.directory? }.first
    end

  end

end