import Foundation

// MARK: - Category-based Word Sets

struct CategoryWordSets {
    // Dictionary of words by category
    static let wordsByCategory: [WordCategory: [Word]] = [
        .science: scienceWords,
        .business: businessWords,
        .arts: artsWords,
        .technology: technologyWords,
        .academic: academicWords,
        .everyday: everydayWords,
    ]

    // Science category words
    static let scienceWords: [Word] = [
        Word(
            term: "photosynthesis",
            pronunciation: "/ˌfoʊtoʊˈsɪnθəsɪs/",
            partOfSpeech: "noun",
            definition:
                "The process by which green plants and some other organisms use sunlight to synthesize foods with carbon dioxide and water.",
            example: "Photosynthesis is crucial for maintaining oxygen levels in the atmosphere."
        ),
        Word(
            term: "quantum",
            pronunciation: "/ˈkwɑːntəm/",
            partOfSpeech: "noun",
            definition:
                "A discrete quantity of energy proportional in magnitude to the frequency of the radiation it represents.",
            example:
                "The quantum theory revolutionized our understanding of atomic and subatomic processes."
        ),
        Word(
            term: "entropy",
            pronunciation: "/ˈɛntrəpi/",
            partOfSpeech: "noun",
            definition:
                "A thermodynamic quantity representing the unavailability of a system's thermal energy for conversion into mechanical work.",
            example:
                "The second law of thermodynamics states that entropy always increases in an isolated system."
        ),
        Word(
            term: "catalyst",
            pronunciation: "/ˈkætəlɪst/",
            partOfSpeech: "noun",
            definition:
                "A substance that increases the rate of a chemical reaction without itself undergoing any permanent chemical change.",
            example: "Enzymes act as catalysts in biochemical reactions in living organisms."
        ),
        Word(
            term: "hypothesis",
            pronunciation: "/haɪˈpɒθəsɪs/",
            partOfSpeech: "noun",
            definition:
                "A proposed explanation for a phenomenon, made on the basis of limited evidence as a starting point for further investigation.",
            example:
                "The scientist developed a hypothesis to explain the unexpected experimental results."
        ),
    ]

    // Business category words
    static let businessWords: [Word] = [
        Word(
            term: "acquisition",
            pronunciation: "/ˌækwɪˈzɪʃən/",
            partOfSpeech: "noun",
            definition: "The buying or obtaining of assets or objects.",
            example:
                "The company's acquisition of its rival created the largest firm in the industry."
        ),
        Word(
            term: "diversification",
            pronunciation: "/daɪˌvɜrsɪfɪˈkeɪʃən/",
            partOfSpeech: "noun",
            definition:
                "The process of a business enlarging or varying its range of products or field of operation.",
            example:
                "Diversification into new markets helped the company survive the economic downturn."
        ),
        Word(
            term: "leverage",
            pronunciation: "/ˈlɛvərɪdʒ/",
            partOfSpeech: "noun",
            definition:
                "The use of borrowed capital for an investment, expecting the profits made to be greater than the interest payable.",
            example: "The firm used leverage to finance its expansion into international markets."
        ),
        Word(
            term: "scalability",
            pronunciation: "/ˌskeɪləˈbɪləti/",
            partOfSpeech: "noun",
            definition:
                "The capability of a system, network, or process to handle a growing amount of work, or its potential to be enlarged to accommodate that growth.",
            example:
                "The startup's business model demonstrated excellent scalability, allowing rapid expansion."
        ),
        Word(
            term: "synergy",
            pronunciation: "/ˈsɪnərdʒi/",
            partOfSpeech: "noun",
            definition:
                "The interaction or cooperation of two or more organizations, substances, or other agents to produce a combined effect greater than the sum of their separate effects.",
            example:
                "The merger created synergy between the two companies' complementary product lines."
        ),
    ]

    // Arts category words
    static let artsWords: [Word] = [
        Word(
            term: "juxtaposition",
            pronunciation: "/ˌdʒʌkstəpəˈzɪʃən/",
            partOfSpeech: "noun",
            definition:
                "The fact of two things being seen or placed close together with contrasting effect.",
            example:
                "The juxtaposition of bright colors in the painting created a striking visual effect."
        ),
        Word(
            term: "renaissance",
            pronunciation: "/ˈrɛnəsɑːns/",
            partOfSpeech: "noun",
            definition: "A revival of or renewed interest in something.",
            example: "The city experienced a cultural renaissance after the new arts center opened."
        ),
        Word(
            term: "chiaroscuro",
            pronunciation: "/kiˌɑːrəˈskjʊəroʊ/",
            partOfSpeech: "noun",
            definition: "The treatment of light and shade in drawing and painting.",
            example:
                "Rembrandt was a master of chiaroscuro, using it to create dramatic effects in his portraits."
        ),
        Word(
            term: "soliloquy",
            pronunciation: "/səˈlɪləkwi/",
            partOfSpeech: "noun",
            definition:
                "An act of speaking one's thoughts aloud when by oneself or regardless of any hearers, especially by a character in a play.",
            example:
                "Hamlet's 'To be or not to be' soliloquy is one of the most famous in Shakespeare's works."
        ),
        Word(
            term: "avant-garde",
            pronunciation: "/ˌævɒnt ˈɡɑːrd/",
            partOfSpeech: "noun",
            definition:
                "New and unusual or experimental ideas, especially in the arts, or the people introducing them.",
            example:
                "The gallery specializes in avant-garde art that challenges conventional aesthetics."
        ),
    ]

    // Technology category words
    static let technologyWords: [Word] = [
        Word(
            term: "algorithm",
            pronunciation: "/ˈælɡəˌrɪðəm/",
            partOfSpeech: "noun",
            definition:
                "A process or set of rules to be followed in calculations or other problem-solving operations, especially by a computer.",
            example: "The search engine uses a complex algorithm to rank web pages."
        ),
        Word(
            term: "blockchain",
            pronunciation: "/ˈblɒktʃeɪn/",
            partOfSpeech: "noun",
            definition:
                "A system in which a record of transactions made in bitcoin or another cryptocurrency are maintained across several computers that are linked in a peer-to-peer network.",
            example: "Blockchain technology has applications beyond cryptocurrency."
        ),
        Word(
            term: "encryption",
            pronunciation: "/ɪnˈkrɪpʃən/",
            partOfSpeech: "noun",
            definition:
                "The process of converting information or data into a code, especially to prevent unauthorized access.",
            example:
                "End-to-end encryption ensures that only the intended recipient can read the message."
        ),
        Word(
            term: "virtualization",
            pronunciation: "/ˌvɜrtʃuəlɪˈzeɪʃən/",
            partOfSpeech: "noun",
            definition:
                "The act of creating a virtual (rather than actual) version of something, including virtual computer hardware platforms, storage devices, and computer network resources.",
            example:
                "Virtualization allows multiple operating systems to run on a single physical server."
        ),
        Word(
            term: "middleware",
            pronunciation: "/ˈmɪdəlˌwɛər/",
            partOfSpeech: "noun",
            definition:
                "Software that acts as a bridge between an operating system or database and applications, especially on a network.",
            example:
                "The middleware layer enables different software applications to communicate with each other."
        ),
    ]

    // Academic category words
    static let academicWords: [Word] = [
        Word(
            term: "paradigm",
            pronunciation: "/ˈpærəˌdaɪm/",
            partOfSpeech: "noun",
            definition: "A typical example or pattern of something; a model.",
            example: "The discovery resulted in a paradigm shift in scientific thinking."
        ),
        Word(
            term: "empirical",
            pronunciation: "/ɪmˈpɪrɪkəl/",
            partOfSpeech: "adjective",
            definition:
                "Based on, concerned with, or verifiable by observation or experience rather than theory or pure logic.",
            example: "The study provided empirical evidence to support the hypothesis."
        ),
        Word(
            term: "pedagogy",
            pronunciation: "/ˈpɛdəˌɡoʊdʒi/",
            partOfSpeech: "noun",
            definition:
                "The method and practice of teaching, especially as an academic subject or theoretical concept.",
            example: "The university offers courses in pedagogy for aspiring teachers."
        ),
        Word(
            term: "epistemology",
            pronunciation: "/ɪˌpɪstəˈmɒlədʒi/",
            partOfSpeech: "noun",
            definition:
                "The theory of knowledge, especially with regard to its methods, validity, and scope, and the distinction between justified belief and opinion.",
            example: "The philosophy course covered epistemology and the nature of knowledge."
        ),
        Word(
            term: "dissertation",
            pronunciation: "/ˌdɪsərˈteɪʃən/",
            partOfSpeech: "noun",
            definition:
                "A long essay on a particular subject, especially one written for a university degree or diploma.",
            example: "She spent a year researching and writing her doctoral dissertation."
        ),
    ]

    // Everyday category words
    static let everydayWords: [Word] = [
        Word(
            term: "serendipity",
            pronunciation: "/ˌsɛrənˈdɪpɪti/",
            partOfSpeech: "noun",
            definition:
                "The occurrence and development of events by chance in a happy or beneficial way.",
            example: "Finding that rare book at a garage sale was pure serendipity."
        ),
        Word(
            term: "ubiquitous",
            pronunciation: "/juːˈbɪkwɪtəs/",
            partOfSpeech: "adjective",
            definition: "Present, appearing, or found everywhere.",
            example: "Smartphones have become ubiquitous in modern society."
        ),
        Word(
            term: "procrastinate",
            pronunciation: "/proʊˈkræstɪˌneɪt/",
            partOfSpeech: "verb",
            definition: "Delay or postpone action; put off doing something.",
            example: "He procrastinated until the deadline was imminent."
        ),
        Word(
            term: "meticulous",
            pronunciation: "/məˈtɪkjələs/",
            partOfSpeech: "adjective",
            definition: "Showing great attention to detail; very careful and precise.",
            example: "She was meticulous in her preparation for the presentation."
        ),
        Word(
            term: "resilience",
            pronunciation: "/rɪˈzɪliəns/",
            partOfSpeech: "noun",
            definition: "The capacity to recover quickly from difficulties; toughness.",
            example: "The community showed remarkable resilience in the aftermath of the disaster."
        ),
    ]

    // Function to get words based on selected categories
    static func getWordsForCategories(_ categories: [WordCategory]) -> [Word] {
        var words: [Word] = []
        
        for category in categories {
            switch category {
            case .everyday:
                words.append(Word(
                    term: "Serendipity",
                    pronunciation: "/ˌserənˈdipəti/",
                    partOfSpeech: "noun",
                    definition: "The occurrence and development of events by chance in a happy or beneficial way",
                    example: "Finding a great book while looking for something else was pure serendipity",
                    category: .everyday
                ))
                
            case .business:
                words.append(Word(
                    term: "Synergy",
                    pronunciation: "/ˈsinərjē/",
                    partOfSpeech: "noun",
                    definition: "The interaction of elements that when combined produce a total effect that is greater than the sum of the individual elements",
                    example: "The merger created synergy between the two companies",
                    category: .business
                ))
                
            case .academic:
                words.append(Word(
                    term: "Hypothesis",
                    pronunciation: "/hīˈpäTHəsəs/",
                    partOfSpeech: "noun",
                    definition: "A proposed explanation for a phenomenon",
                    example: "The scientist developed a hypothesis about the effect of sunlight on plant growth",
                    category: .academic
                ))
                
            case .technology:
                words.append(Word(
                    term: "Algorithm",
                    pronunciation: "/ˈalɡəˌriT͟Həm/",
                    partOfSpeech: "noun",
                    definition: "A process or set of rules to be followed in calculations or other problem-solving operations",
                    example: "The search engine uses a complex algorithm to rank web pages",
                    category: .technology
                ))
                
            case .science:
                words.append(Word(
                    term: "Quantum",
                    pronunciation: "/ˈkwäntəm/",
                    partOfSpeech: "noun",
                    definition: "A discrete quantity of energy proportional in magnitude to the frequency of the radiation it represents",
                    example: "The physicist studied the quantum behavior of particles",
                    category: .science
                ))
                
            case .arts:
                words.append(Word(
                    term: "Aesthetic",
                    pronunciation: "/esˈTHedik/",
                    partOfSpeech: "adjective",
                    definition: "Concerned with beauty or the appreciation of beauty",
                    example: "The gallery's aesthetic appeal drew many visitors",
                    category: .arts
                ))
            }
        }
        
        return words.shuffled()
    }
}
