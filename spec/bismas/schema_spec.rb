describe Bismas::Schema do

  subject { described_class.parse_file(data('test.cat')) }

  example do
    expect(subject.title).to eq(*encode("Literatur zur Inhaltserschlie\xE1ung"))
  end

  example do
    expect(subject.name).to eq('LIT')
  end

  example do
    expect(subject.category_length).to eq(4)
  end

  example do
    expect(subject.categories).to eq(%w[
      005 010 015 017 020 025 027 030 035 045 050 051 052 053 055 056 057 058
      059 060 065 070 080 100 101 102 103 104 105 106 107 108 109 110 115 120
      122 125 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145
      146 148 150 152
    ])
  end

  example do
    expect(subject['000']).to be_nil
  end

  {
    '005' => '1. Verfasser',
    '015' => '3. Verfasser',
    '020' => 'Hauptsachtitel',
    '027' => 'Ausgabevermerk',
    '035' => 'Serientitel',
    '050' => 'Verlag',
    '052' => 'ISBN',
    '055' => 'Erscheinungsjahr',
    '057' => 'Inhalt',
    '059' => 'Sprache',
    '065' => 'Themenbereich',
    '080' => 'Behandelte Form',
    '101' => 'Objekt',
    '103' => 'Objekt',
    '115' => 'Fachgebiet',
    '120' => 'Land/Ort',
    '122' => 'Sparte',
    '130' => 'DDC',
    '140' => 'Biographierte',
    '145' => 'Bild',
    '148' => 'Einstufung',
    '150' => 'Datum1',
    '152' => 'Datum2'
  }.each { |k, v| example { expect(subject[k]).to eq(*encode(v)) } }

end
