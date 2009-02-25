
describe Redcar::ProjectTab do
  before(:each) do
    @tab = Redcar.win.new_tab(Redcar::ProjectTab)
    @tab.clear
  end

  after(:each) do
    @tab.close
  end

  it "should set the title" do
    @tab.title.should == "Project"
  end

  describe "adding a project directory" do
    before(:each) do
      @tab.add_directory("project", Redcar.PLUGINS_PATH + "/project")
    end

    it "should add the files" do
      @tab.store.contents(2).should include(Redcar.PLUGINS_PATH + "/project/spec")
    end

    it "should not add sub directories" do
      @tab.store.contents(2).should_not include(Redcar.PLUGINS_PATH + "/project/spec/tabs")
    end

    it "should have short names for files" do
      @tab.store.contents(1).should include("spec")
    end

    it "should create dummy rows under directories (so the open arrow appears)" do
      @tab.store.contents(1).should include("[dummy row]")
      @tab.store.contents(2).should include(Redcar.PLUGINS_PATH + "/project/spec/[dummy row]")
    end

    it "should have the directory" do
      @tab.directories.should include(Redcar.PLUGINS_PATH + "/project")
    end
  end
  
  describe ".remove_project" do
    before(:each) do
      @tab.add_directory("project", Redcar.PLUGINS_PATH + "/project")
    end
    
    it "should remove the project" do
      @tab.store.contents(1).should include("project")
      @tab.remove_project(Redcar.PLUGINS_PATH + "/project")
      @tab.store.contents(1).should_not include("project")
    end
    
    it "should remove the project even if given a sub-directory" do
      @tab.store.contents(1).should include("project")
      @tab.remove_project(Redcar.PLUGINS_PATH + "/project/commands")
      @tab.store.contents(1).should_not include("project")
    end
  end

  describe "opening a directory", :shared => true do
    before(:each) do
      @tab.add_directory("project", Redcar.PLUGINS_PATH + "/project")
    end
    
    after(:each) do
      FileUtils.rm_f(Redcar.PLUGINS_PATH + "/project/spec/test.tmp")
    end
    
    it "should add subdirectories" do
      open_dir
      @tab.store.contents(2).should include(Redcar.PLUGINS_PATH + "/project/spec/tabs")
    end
    
    it "should only add directories once" do
      open_dir
      open_dir
      @tab.store.contents(2).scan("/project/spec/tabs\n").length.should == 1
    end
    
    it "should remove the dummy row" do
      open_dir
      @tab.store.contents(2).should_not include(Redcar.PLUGINS_PATH + "/project/spec/[dummy row]")
    end
    
    it "should reload directories" do
      new_file = Redcar.PLUGINS_PATH + "/project/spec/test.tmp"
      FileUtils.rm_f(new_file)
      open_dir
      @tab.store.contents(2).should_not include(new_file)
      File.open(new_file, "w") do |f|
        f.puts "foo"
      end
      open_dir
      @tab.store.contents(2).should include(new_file)
    end
  end
  
  describe "opening a directory by activating the row" do
    it_should_behave_like "opening a directory"
    
    def open_dir
      i = @tab.store.find_iter(1, "spec")
      @tab.open_row(i.path.to_s)
    end
  end
  
  describe "opening a directory by expanding the row" do
		it_should_behave_like "opening a directory"
		
    def open_dir
      i = @tab.store.find_iter(1, "spec")
      @tab.view.selection.select_iter(i)
      @tab.view.signal_emit(:row_expanded, i, i.path)
    end
  end

  describe "adding a file", :shared => true do
    before(:each) do
      @tab.add_directory("project", Redcar.PLUGINS_PATH + "/project")
    end
    
    it "should append an iter to the directory" do
      add_file
      @tab.store.contents(1).should include("unknown")
    end
    
    it "should create the file" do
      add_file
      File.exist?(@tab.store.find_iter(1, "unknown")[2]).should be_true
    end
  end

  describe "adding a file" do
    describe "to an open directory by clicking on the file" do
      it_should_behave_like "adding a file"
      
      def add_file
        iter = @tab.store.find_iter(1, "deps.rb")
        @tab.new_file_at(iter[2])
      end
      
      after(:each) do
        FileUtils.rm_f(Redcar.PLUGINS_PATH + "/project/unknown")
      end
    end
    
    describe "to an open directory by clicking on the directory" do
      it_should_behave_like "adding a file"
      
      def add_file
        iter = @tab.store.find_iter(1, "spec")
        @tab.open_row(iter.path)
        iter = @tab.store.find_iter(1, "spec")
        @tab.new_file_at(iter[2])
      end
      
      after(:each) do
        FileUtils.rm_f(Redcar.PLUGINS_PATH + "/project/spec/unknown")
      end
    end
    
    describe "to a closed directory by clicking on the directory" do
      it_should_behave_like "adding a file"
      
      it "should open the directory" do
        add_file
        @tab.store.find_iter(1, "test_spec.rb").should_not be_nil
      end
      
      def add_file
        iter = @tab.store.find_iter(1, "spec")
        @tab.new_file_at(iter[2])
      end
      
      after(:each) do
        FileUtils.rm_f(Redcar.PLUGINS_PATH + "/project/spec/unknown")
      end
    end
  end
end
