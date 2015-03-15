class Transcription < ActiveRecord::Base
  has_many :scans
  validates :path_to_xml_file, uniqueness: true, presence: true

  def xml_content

    xml_text = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<?xml-model href=\"http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng\" type=\"application/xml\" schematypens=\"http://relaxng.org/ns/structure/1.0\"?>\n<?xml-model href=\"http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng\" type=\"application/xml\"\n\tschematypens=\"http://purl.oclc.org/dsdl/schematron\"?>\n<TEI xmlns=\"http://www.tei-c.org/ns/1.0\">\n  <teiHeader>\n      <fileDesc>\n
        <titleStmt>\n
        <title>Registre</title>\n
        <author>\n
          <name>\n
            <forename>Jean</forename>\n
            <surname>Maillefer</surname>\n
          </name>\n
        </author>\n
        </titleStmt>\n         <publicationStmt>\n            <p>Publication Information</p>\n         </publicationStmt>\n         <sourceDesc>\n            <p>Information about the source</p>\n         </sourceDesc>\n      </fileDesc>\n  </teiHeader>\n  <text>\n      <body>\n         <div type=\"volume\">\n            <pb n=\"1r\"/>\n               <p> \n

      <lb/>
        <add place=\"margin_left\"> \n
        Commencé le\n
        <lb/><date calendar=\"gregorian\" when=\"1667-06-01\">premier Juing\n                     <lb/>1667</date>\n                  </add>\n               </p>\n               <p>\n                  <lb/><title>au publique</title>\n               </p>\n                  <p>\n                     <lb/>Monseigneur \n                  </p>\n               <p>\n                  <lb/>dans un long ennuye, pour des Raisons qui vous ennuiroient\n                  <lb/>a les entendre et moy daduantage a vous les dire, qui nous sont\n                  <lb/>neantmoing Communes mais une principalle Cest que me\n                  <lb/>voyant Jnutil a cause de mon Jnfirmité de l'ouye de\n                  <lb/>vous faire seruire ou de vous  estre vtil Jay esté beaucoup\n                  <lb/>Consolé que dieu mayt donné huict fils sans Compter\n                  <lb/>les filles lesquels sy Jls mobeissent seront vos seruiteurs\n                  <lb/>et Repareront les pertes que vous Recepues a tous moments\n                  <lb/>de quelqueunes de vos parties Ce quy ne mayant pas <choice><abbr>entierem<c>t</c></abbr><expan>entierement</expan></choice>\n                  <lb/>satisfait Jay esté bien aisé de vous embelire dans vn\n                  <lb/>abandonnement que on peut dire quasy general ou vous\n                  <lb/>est soit par la negligence l'imposibilité ou le trop grand\n                  <lb/>menage de Ceux qui vous Composent et pour Ce Jay fait\n                  <lb/>batir auecq le plus de simetrye et que le lieu ma peue\n                  <lb/>permettre Car on dit et Jl est vraye que les bastiments\n                  <lb/>vous ornent autant et plus que les point peruques brocarts\n                  <lb/>estophes Rayes font plusieurs de vos Jndiuidus\n                  <lb/>Monseigneur donques\n                  <lb/>Je die a vos beaux esprits\n                  <lb/>que je Reueue Ces escrits\n                  <lb/>a ne vous en pas mentir\n                  <lb/>Je Retranché la satir\n                  <lb/>Sy vous me demandes quelle fin encore Je me propose Je vous\n                  <lb/>diray que Ce nest ny la gloire ny linterest la premiere\n                  <lb/>est belle mais pour lacquerir la faut fuire et elle suit\n                  <lb/>laultre est necessaire Ce a esté pour moccuper aux heures\n                  <lb/>que je ne scay que faire ny mesme me diuertir et pour\n                  <lb/>minstruire et pour seruir a mes enfans Cest tout sur\n                  <lb/>la moralle et du Commerce Cest lhonneste et lutil\n                  <lb/>que naye je des puissances proportionnes a mes\n                  <lb/>mouuements et aux desirs de vous tesmoigner que\n                  <lb/>Je vous suis\n               </p>                  \n               <p>\n                  <lb/>Monse<unclear reason=\"stain\">igne</unclear>ur                 Vostre\n               </p>\n
  <pb n=\"1v\"/>\n
  <pb n=\"2r\"/>\n
                    <p>\n               <lb/><title>au lecteur</title>   \n            </p>\n            <p>\n               <lb/>Mon cher lecteur\n               <lb/>Cela sentend sy vous lizés Ie ne vous demande \n               <lb/>vostre approbation ny Je ne me soucye de vostre\n               <lb/>Censure on scait asses que Il ny a personne Dont\n               <lb/>les escrits ou les art\n            </p>\n         </div>\n      </body>\n  </text>\n</TEI>\n"
    return xml_text
    # client = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])
    # content = client.contents('antoineodier/egodocuments-transcriptions', path: self.path_to_xml_file).content
    # text = Base64.decode64(content)
    # return text
  end

end