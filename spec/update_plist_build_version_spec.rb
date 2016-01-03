require 'spec_helper'

describe UpdatePlistBuildVersion do
  before(:each) do
    sample_path = File.join(File.dirname(__FILE__), 'sample_info.plist')
    @info_plist = File.join(File.dirname(__FILE__), 'info.plist')
    @today_plist = File.join(File.dirname(__FILE__), 'info_today.plist')
    @tommorrow_plist = File.join(File.dirname(__FILE__), 'info_tommorrow.plist')
    @before_month_plist = File.join(File.dirname(__FILE__), 'info_before_month.plist')
    @next_month_plist = File.join(File.dirname(__FILE__), 'info_next_month.plist')
    @before_year_plist = File.join(File.dirname(__FILE__), 'info_before_year.plist')
    @next_year_plist = File.join(File.dirname(__FILE__), 'info_next_year.plist')
    FileUtils.copy(sample_path, @info_plist)
  end

  after(:each) do
    info_plist = File.join(File.dirname(__FILE__), 'info.plist')
    File.unlink(info_plist)
  end

  it 'has a version number' do
    expect(UpdatePlistBuildVersion::VERSION).not_to be nil
  end

  it 'create runner instance' do
    opts = {:src_file => @info_plist}
    runner = UpdatePlistBuildVersion::Runner.new(opts)
    expect(runner).to be_an_instance_of UpdatePlistBuildVersion::Runner
  end

  it 'raise if source file path is nil' do
    opts = {:src_file => nil}    
    expect { UpdatePlistBuildVersion::Runner.new(opts) }.to raise_error(ArgumentError)
  end

  it 'raise if source file is not exist' do
    opts = {:src_file => "./not_exist.plist"}
    expect { UpdatePlistBuildVersion::Runner.new(opts) }.to raise_error(ArgumentError)
  end

  it "dst_file equal to src_file if dst_file is not added" do
    opts = {:src_file => @info_plist}
    runner = UpdatePlistBuildVersion::Runner.new(opts)
    expect(runner.src_path).to eq(@info_plist)
    expect(runner.dst_path).to eq(runner.src_path)
  end

  it "increment miner version number if today" do
    opts = {:src_file => @info_plist}
    runner = UpdatePlistBuildVersion::Runner.new(opts)
    runner.today = Time.mktime(2015, 12, 14)

    next_version,_ = runner.run
    expect(next_version).to eq("20151214.1")

    next_version,xml = runner.run
    expect(next_version).to eq("20151214.2")

    expect(File.open(@info_plist) {|f| f.read}).to eq(File.open(@today_plist) {|f| f.read})
  end

  it "increment major version number if not today" do
    opts = {:src_file => @info_plist}
    runner = UpdatePlistBuildVersion::Runner.new(opts)
    runner.today = Time.mktime(2015, 12, 15)

    next_version,_ = runner.run
    expect(next_version).to eq("20151215.0")

    expect(File.open(@info_plist) {|f| f.read}).to eq(File.open(@tommorrow_plist) {|f| f.read})
  end

  it "next month" do
    opts = {:src_file => @before_month_plist, :dst_file => @info_plist}
    runner = UpdatePlistBuildVersion::Runner.new(opts)
    runner.today = Time.mktime(2015, 12, 1)
    runner.run
    expect(File.open(@info_plist) {|f| f.read}).to eq(File.open(@next_month_plist) {|f| f.read})
  end

  it "next year" do
    opts = {:src_file => @before_year_plist, :dst_file => @info_plist}
    runner = UpdatePlistBuildVersion::Runner.new(opts)
    runner.today = Time.mktime(2016, 1, 1)
    runner.run
    expect(File.open(@info_plist) {|f| f.read}).to eq(File.open(@next_year_plist) {|f| f.read})
  end

end
