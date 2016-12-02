describe Notify do
  before :each do
    @class_name = (0..6).map { (65 + rand(26)).chr }.join.capitalize # To ensure the attr_ methods are not dependent on class name
    eval(
      "class #{@class_name};"\
        'def initialize;'\
          '@var = \'variable\';'\
        'end;'\
      'end'
    )
  end
  # Teardown
  after :each do
    Object.send(:remove_const, @class_name.to_sym)
  end

  it 'should read and show that attributes are being read with attr_reader' do
    eval(
      "class #{@class_name};"\
        'Notify.attr_reader :var;'\
      'end'
    )
    expect(STDOUT).to receive(:puts).with('The value of @var is "variable" (String)')
    expect(Object.const_get(@class_name).new.var).to eq 'variable'
  end

  it 'should not allow attributes to be set with only attr_reader' do
    eval(
      "class #{@class_name};"\
        'Notify.attr_reader :var;'\
      'end;'
    )
    expect { Object.const_get(@class_name).new.var = 12 }.to raise_error NoMethodError
  end

  it 'should set and show that attributes are being set with attr_writer' do
    eval(
      "class #{@class_name};"\
        'Notify.attr_writer :var;'\
      'end'
    )
    test = Object.const_get(@class_name).new
    expect(STDOUT).to receive(:puts).with('Setting @var to "2" (Fixnum)')
    test.var = 2
    expect(test.instance_variable_get('@var')).to eq 2
  end

  it 'should not allow attributes to be read with only attr_writer' do
    eval(
      "class #{@class_name};"\
        'Notify.attr_writer :var;'\
      'end'
    )
    expect { Object.const_get(@class_name).new.var }.to raise_error NoMethodError
  end

  it 'should give both attr_reader and attr_writer with attr_accessor' do
    eval(
      "class #{@class_name};"\
        'Notify.attr_accessor :var;'\
      'end'
    )
    test = Object.const_get(@class_name).new
    new_value = {key: 'value'}
    expect(STDOUT).to receive(:puts).with('Setting @var to "{:key=>"value"}" (Hash)')
    test.var = new_value
    expect(STDOUT).to receive(:puts).with('The value of @var is "{:key=>"value"}" (Hash)')
    expect(test.var).to eq new_value
  end
end
