describe Bismas::Reader do

  def parse_file(options = {})
    described_class.parse_file(data('test.dat'), options)
  end

  example do
    expect(parse_file.size).to eq(14)
  end

  example do
    expect(parse_file(encoding: nil).size).to eq(14)
  end

  example do
    expect(parse_file(encoding: Encoding::CP850).size).to eq(14)
  end

  example do
    expect{silence{parse_file(encoding: '')}}.to raise_error(TypeError, 'no implicit conversion of nil into String')
  end

  example do
    expect(parse_file(strict: true)).to eq({
      1  => { "005" => ["Bock, F."], "020" => ["Zur Geschichte des Schlagwortkatalogs in Praxis und Theorie"], "030" => ["Zentralblatt f\x81r Bibliothekswesen. 40(1923), S.494-502."], "055" => ["1923"], "060" => ["Geschichte des Schlagwortkataloges"], "059" => ["d"], "053" => ["a"], "120" => ["D"] },
      2  => { "005" => ["Bravo, B.R. => Rodriguez Bravo, B."], "150" => ["22. 4.2007 19:43:53"] },
      3  => { "005" => ["Simmons, P."], "020" => ["Microcomputer software for ISO 2709 record conversion"], "030" => ["Microcomputers for information management. 6(1989), S.197-205."], "055" => ["1989"], "060" => ["Bibliographische Software"], "053" => ["a"], "059" => ["e"], "100" => ["ISO 2709"], "065" => ["Datenformate"] },
      4  => { "005" => ["Fugmann, R."], "020" => ["\xAADie Aufgabenteilung zwischen Wortschatz und Grammatik in einer Indexsprache"], "030" => ["Datenbasen, Datenbanken, Netzwerke. Bd.1."], "045" => ["M\x81nchen"], "055" => ["1979"], "060" => ["Theorie verbaler Dokumentationssprachen"], "051" => ["S.67-93"], "059" => ["d"], "053" => ["a"] },
      5  => { "005" => ["Babu, B.Ramesh => Ramesh Babu, B."], "150" => ["10.12.2005 11:31:20"] },
      6  => { "005" => ["Rau, P."], "020" => ["\xAADie Facettenmethode und ihre Anwendung auf die Philologie"], "055" => ["1970"], "045" => ["Hamburg"], "058" => ["Assessorarbeit"], "053" => ["x"], "059" => ["d"], "115" => ["Geisteswissenschaften"] },
      7  => { "005" => ["Bo\xE1meyer, C."], "020" => ["RSWK-Anwendung und Schlagwortnormdatei unter Einsatz der Datenverarbeitung"], "030" => ["Zeitschrift f\x81r Bibliothekswesen und Bibliographie. 35(1988), S.113-121."], "055" => ["1988"], "060" => ["Regeln f\x81r den Schlagwortkatalog (RSWK)"], "100" => ["RSWK"], "101" => ["SWD"], "059" => ["d"], "053" => ["a"] },
      8  => { "005" => ["Bock, K."], "020" => ["RSWK oder der S\x81ndenkatalog"], "030" => ["BuB. 40(1988), S.262-267."], "055" => ["1988"], "060" => ["Regeln f\x81r den Schlagwortkatalog (RSWK)"], "058" => ["Forts. in: BuB 40(1988) S.926-927."], "059" => ["d"], "053" => ["a"] },
      9  => { "005" => ["Bock, K."], "020" => ["RSWK und die entt\x84uschte Liebe"], "030" => ["BuB. 40(1988), S.926-927."], "055" => ["1988"], "060" => ["Regeln f\x81r den Schlagwortkatalog (RSWK)"], "025" => ["ein Nachtrag"], "059" => ["d"], "053" => ["a"], "150" => ["                   "], "152" => [" 7. 4.2001 15:39:33"], "120" => ["D"] },
      10 => { "020" => ["SISIS"], "030" => ["Bibliotheksdienst. 35(2001) H.9, S.1179-1182."], "055" => ["2001"], "053" => ["a"], "059" => ["d"], "150" => ["                   "], "152" => ["29. 9.2001 11:38:17"], "005" => ["Klau\xE1, H."], "025" => ["15. Anwenderforum Berlin-Brandenburg"], "100" => ["SISIS"], "120" => ["Berlin", "Brandenburg", "D"] },
      11 => { "005" => ["Notess, G.R."], "020" => ["Tracking title search capabilities"], "030" => ["Online. 25(2001) no.3, S.72-74."], "053" => ["a"], "055" => ["2001"], "059" => ["e"], "060" => ["Volltextretrieval"], "150" => [" 5. 6.2001 11:36:02"] },
      12 => { "005" => ["G\x94dert, W."], "020" => ["Online-Katalog und bibliothekarische Inhaltserschlie\xE1ung"], "030" => ["77. Deutscher Bibliothekartag in Augsburg 1987. Reden und Vortr\x84ge. Hrsg.: Y.A. Haase u.a."], "045" => ["Frankfurt a.M."], "055" => ["1988"], "060" => ["Grundlagen u. Einf\x81hrungen: Allgemeine Literatur"], "065" => ["Regeln f\x81r den Schlagwortkatalog (RSWK)"], "050" => ["Klostermann"], "035" => ["Zeitschrift f\x81r Bibliothekswesen und Bibliographie: Sonderh.46"], "051" => ["S.279-302"], "053" => ["a"], "059" => ["d"] },
      13 => { "005" => ["Aluri, R.D."], "010" => ["Kemp, A."], "015" => ["Boll, J.J."], "020" => ["Subject analysis in online catalogs"], "045" => ["Englewood, CO"], "050" => ["Libraries Unlimited"], "055" => ["1991"], "060" => ["Klassifikationssysteme im Online-Retrieval"], "065" => ["Verbale Doksprachen im Online-Retrieval"], "058" => ["Rez. in: Technical services quarterly. 9(1992) no.3, S.87-88 (H.L. Hoerman); Knowledge organization 20(1993) no.3, S.165-166 (O. Oberhauser); JASIS 44(1993) S.593 (D. Vizine-Goetz)", "\r\r2. Aufl. unter: Olson, H.A., J.J. Boll: Subject access in online catalogs. 2nd ed. Englewood, CO: Libraries Unlimited 2001. xv, 333 S. ISBN 1-56308-800-2"], "051" => ["XII,303 S"], "052" => ["0-87287-670-5"], "053" => ["m"], "059" => ["e"], "130" => ["025.3'132--dc20"], "131" => ["Z699.35.S92A46 1990"], "136" => ["Catalogs, On-line--Subject access", "Subject cataloguing--Data processing", "Machine-readable bibliographic data", "Information retrieval"], "150" => ["                   "], "152" => ["26. 8.2005 15:16:28"] },
      14 => { "020" => ["Multilingual information management"], "055" => ["1999"], "059" => ["e"], "060" => ["Multilinguale Probleme"], "150" => [" 2. 8.2001  9:04:29"], "017" => ["Hovy, N. et al."], "025" => ["current levels and future abilities. A report commissioned by the US National Science Foundation and also delivered to the European's Commission's Language Engineering Office and the US Defense Advanced Research Projects Agency"], "050" => ["US National Science Foundation"], "058" => ["Vgl. auch: http://www.cs.cmu.edu/~ref/mlim/index.shtml"], "045" => ["?"], "056" => ["Over the past 50 years, a variety of language-related capabilities has been developed in machine translation, information retrieval, speech recognition, text summarization, and so on. These applications rest upon a set of core techniques such as language modeling, information extraction, parsing, generation, and multimedia planning and integration; and they involve methods using statistics, rules, grammars, lexicons, ontologies, training techniques, and so on. It is a puzzling fact that although all of this work deals with language in some form or other, the major applications have each developed a separate research field. For example, there is no reason why speech recognition techniques involving n-grams and hidden Markov models could not have been used in machine translation 15 years earlier than they were, or why some of the lexical and semantic insights from the subarea called Computational Linguistics are still not used in information retrieval. This picture will rapidly change. The twin challenges of massive information overload via the web and ubiquitous computers present us with an unavoidable task: developing techniques to handle multilingual and multi-modal information robustly and efficiently, with as high quality performanceas possible.  The most effective way for us to address such a mammoth task, and to ensure that our various techniques and applications fit together, is to start talking  across the artificial research boundaries. Extending the current technologies will require integrating the various capabilities into multi-functional and multi-lingual natural language systems. However, at this time there is no clear vision of how these technologies could or should be assembled into a coherent framework. What would be involved in connecting a speech recognition system to an information retrieval engine, and then using machine translation and summarization software to process the retrieved text? How can traditional parsing and generation be enhanced with statistical techniques? What would be the effect of carefully crafted lexicons on traditional information retrieval? At which points should machine translation be interleaved within information retrieval systems to"] }
    }.each_value { |h| h.each_value { |a| encode(*a) } })
  end

end
