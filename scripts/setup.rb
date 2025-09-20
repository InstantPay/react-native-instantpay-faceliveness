require 'fileutils'
require 'xcodeproj'

#path to the ios directory of the project
$targetName = "" #name of the target in the Xcode project

PROJ_DIR = File.expand_path('..', __dir__)

LIB_IOS_PATH = File.expand_path("../ios", __dir__) #path to the ios directory of the library

#Development Library path
DEV_IOS_PATH = File.expand_path("../example/ios", __dir__)

#Live Library path
PROD_IOS_PATH = File.join(PROJ_DIR, "ios")

COPY_FOLDER = "ipayFacelivenessModule"

def setup_faceliveness(config)
    if config.nil? || !config.is_a?(Object) || config.empty? || config.length == 0
        log("Invalid config argument", "error")
        exit(0)
    end

    if !config.has_key?("targetName") || config["targetName"].nil? || config["targetName"].to_s.strip.length == 0
        log("Invalid targetName in config argument", "error")
        exit(0)
    end

    $targetName = config["targetName"].to_s.strip

    targetModuleDir = ""
    #check development library path
    if File.exist?(DEV_IOS_PATH) || File.directory?(DEV_IOS_PATH)
        targetModuleDir = DEV_IOS_PATH
        log("Development Library path found: " + DEV_IOS_PATH, "success")
    #check live library path
    elsif File.exist?(PROD_IOS_PATH) || File.directory?(PROD_IOS_PATH)
        targetModuleDir = PROD_IOS_PATH
        log("Live Library path found: " + PROD_IOS_PATH, "success")
    else
        log("Neither Development nor Live Library path found", "error")
        exit(0) 
    end

    targetModulePath = File.join(targetModuleDir, $targetName+".xcodeproj")

    #1. Copy module ios files to project ios directory
    src = File.join(LIB_IOS_PATH, COPY_FOLDER)
    dest = File.join(targetModuleDir,$targetName, COPY_FOLDER)

    #Open Xcode project and get target
    project = Xcodeproj::Project.open(targetModulePath)
    target  = project.targets.find { |t| t.name == $targetName }

    if target.nil?
        log("❌ Target #{$targetName} not found in #{targetModulePath}", "error")
        exit(0)
    end

    remove_folder_reference(project, targetModuleDir, target, dest)

    #exit(0)

    FileUtils.rm_rf(dest) #remove if already exists
    log("🗑️ Remove from #{dest}", "success")

    FileUtils.cp_r(src, dest) #copy folder recursively
    log("✅ Copied to #{dest}", "success")

    #2. Remove Comment From all files
    Dir.glob("#{dest}/**/*.{h,m,mm,swift}") do |file|
        lines = File.readlines(file)
        # Remove first line if it's a comment
        lines.shift if lines.first&.strip&.start_with?("/*")
        # Remove last line if it's a comment
        lines.pop if lines.last&.strip&.start_with?("*/")
        File.write(file, lines.join)
    end
    log("🧹 Cleaned comment lines in #{dest}", "success")

    #3. Link into Xcode target Compile Sources
    #Dir.glob("#{dest}/**/*.{h,m,mm,swift}").each do |file|
    #    relative_path = file.sub(targetModuleDir + "/", "")
    #    file_ref = project.main_group.find_file_by_path(relative_path) || project.main_group.new_file(relative_path)
    #    unless target.source_build_phase.files_references.include?(file_ref)
    #        target.add_file_references([file_ref])
    #        log("📌 Added #{relative_path} to Compile Sources", "success")
    #    end
    #end

    add_folder_reference(project, targetModuleDir, target, dest, $targetName)

    project.save
    log("✅ 🎉 Setup complete!", "success")

    #exit(0)
end

def add_folder_reference(project, targetModuleDir ,target, folder_path, group_name = nil)
    # Create/find a group that points to the folder itself (grey folder style)
    relative_path = folder_path.sub(targetModuleDir + "/", "")

    group = project.main_group.find_subpath(relative_path, true)
    group.set_source_tree('<group>') # makes it a grey folder reference

    # Add all source files inside that folder to compile sources
    Dir.glob("#{folder_path}/**/*.{h,m,mm,swift}").each do |file|
        file_ref = group.new_file(file)

        unless target.source_build_phase.files_references.include?(file_ref)
            target.add_file_references([file_ref])
            log("📌 Linked #{file} (no copy, reference only)", "success")
        end
    end
end

def remove_folder_reference(project, targetModuleDir, target, folder_path)
    relative_path = folder_path.sub(targetModuleDir + "/", "")
    group = project.main_group.find_subpath(relative_path, true)

    return unless group

    # Remove file references from target Compile Sources
    Dir.glob("#{relative_path}/**/*.{h,m,mm,swift}").each do |file|
        file_ref = group.files.find { |f| f.path == file }
        next unless file_ref
        if file_ref
            file_ref.remove_from_project
            log("🗑️ Removed reference for #{file_ref}", "success")
        else
            log("❌ File reference for #{file} not found in project", "error")
        end
    end

    # Remove the group itself (the grey folder reference)
    group.remove_from_project
    project.save
    log("🗑️ Removed folder reference #{group}", "success")
end

def log(message,type="info")

    logTag = colorize("[Faceliveness Setup Log*] ",35)

    if type == "error"
        puts red("#{logTag} #{message}")
    elsif type == "success"
        puts green("#{logTag} #{message}")
    elsif type == "warning"
        puts yellow("#{logTag} #{message}")
    else   
        puts blue("#{logTag} #{message}")
    end
end

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text) 
    colorize(text, 31)
end

def green(text) 
    colorize(text, 32)
end

def yellow(text) 
    colorize(text, 33)
end

def blue(text) 
    colorize(text, 34) 
end