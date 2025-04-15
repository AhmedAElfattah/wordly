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
            example: "Photosynthesis is crucial for maintaining oxygen levels in the atmosphere.",
            category: .science
        ),
        Word(
            term: "quantum",
            pronunciation: "/ˈkwɑːntəm/",
            partOfSpeech: "noun",
            definition:
                "A discrete quantity of energy proportional in magnitude to the frequency of the radiation it represents.",
            example:
                "The quantum theory revolutionized our understanding of atomic and subatomic processes.",
            category: .science
        ),
        Word(
            term: "entropy",
            pronunciation: "/ˈɛntrəpi/",
            partOfSpeech: "noun",
            definition:
                "A thermodynamic quantity representing the unavailability of a system's thermal energy for conversion into mechanical work.",
            example:
                "The second law of thermodynamics states that entropy always increases in an isolated system.",
            category: .science
        ),
        Word(
            term: "catalyst",
            pronunciation: "/ˈkætəlɪst/",
            partOfSpeech: "noun",
            definition:
                "A substance that increases the rate of a chemical reaction without itself undergoing any permanent chemical change.",
            example: "Enzymes act as catalysts in biochemical reactions in living organisms.",
            category: .science
        ),
        Word(
            term: "hypothesis",
            pronunciation: "/haɪˈpɒθəsɪs/",
            partOfSpeech: "noun",
            definition:
                "A proposed explanation for a phenomenon, made on the basis of limited evidence as a starting point for further investigation.",
            example:
                "The scientist developed a hypothesis to explain the unexpected experimental results.",
            category: .science
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
                "The company's acquisition of its rival created the largest firm in the industry.",
            category: .business
        ),
        Word(
            term: "diversification",
            pronunciation: "/daɪˌvɜrsɪfɪˈkeɪʃən/",
            partOfSpeech: "noun",
            definition:
                "The process of a business enlarging or varying its range of products or field of operation.",
            example:
                "Diversification into new markets helped the company survive the economic downturn.",
            category: .business
        ),
        Word(
            term: "leverage",
            pronunciation: "/ˈlɛvərɪdʒ/",
            partOfSpeech: "noun",
            definition:
                "The use of borrowed capital for an investment, expecting the profits made to be greater than the interest payable.",
            example: "The firm used leverage to finance its expansion into international markets.",
            category: .business
        ),
        Word(
            term: "scalability",
            pronunciation: "/ˌskeɪləˈbɪləti/",
            partOfSpeech: "noun",
            definition:
                "The capability of a system, network, or process to handle a growing amount of work, or its potential to be enlarged to accommodate that growth.",
            example:
                "The startup's business model demonstrated excellent scalability, allowing rapid expansion.",
            category: .business
        ),
        Word(
            term: "synergy",
            pronunciation: "/ˈsɪnərdʒi/",
            partOfSpeech: "noun",
            definition:
                "The interaction or cooperation of two or more organizations, substances, or other agents to produce a combined effect greater than the sum of their separate effects.",
            example:
                "The merger created synergy between the two companies' complementary product lines.",
            category: .business
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
                "The juxtaposition of bright colors in the painting created a striking visual effect.",
            category: .arts
        ),
        Word(
            term: "renaissance",
            pronunciation: "/ˈrɛnəsɑːns/",
            partOfSpeech: "noun",
            definition: "A revival of or renewed interest in something.",
            example: "The city experienced a cultural renaissance after the new arts center opened.",
            category: .arts
        ),
        Word(
            term: "chiaroscuro",
            pronunciation: "/kiˌɑːrəˈskjʊəroʊ/",
            partOfSpeech: "noun",
            definition: "The treatment of light and shade in drawing and painting.",
            example:
                "Rembrandt was a master of chiaroscuro, using it to create dramatic effects in his portraits.",
            category: .arts
        ),
        Word(
            term: "soliloquy",
            pronunciation: "/səˈlɪləkwi/",
            partOfSpeech: "noun",
            definition:
                "An act of speaking one's thoughts aloud when by oneself or regardless of any hearers, especially by a character in a play.",
            example:
                "Hamlet's 'To be or not to be' soliloquy is one of the most famous in Shakespeare's works.",
            category: .arts
        ),
        Word(
            term: "avant-garde",
            pronunciation: "/ˌævɒnt ˈɡɑːrd/",
            partOfSpeech: "noun",
            definition:
                "New and unusual or experimental ideas, especially in the arts, or the people introducing them.",
            example:
                "The gallery specializes in avant-garde art that challenges conventional aesthetics.",
            category: .arts
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
            example: "The search engine uses a complex algorithm to rank web pages.",
            category: .technology
        ),
        Word(
            term: "blockchain",
            pronunciation: "/ˈblɒktʃeɪn/",
            partOfSpeech: "noun",
            definition:
                "A system in which a record of transactions made in bitcoin or another cryptocurrency are maintained across several computers that are linked in a peer-to-peer network.",
            example: "Blockchain technology has applications beyond cryptocurrency.",
            category: .technology
        ),
        Word(
            term: "encryption",
            pronunciation: "/ɪnˈkrɪpʃən/",
            partOfSpeech: "noun",
            definition:
                "The process of converting information or data into a code, especially to prevent unauthorized access.",
            example:
                "End-to-end encryption ensures that only the intended recipient can read the message.",
            category: .technology
        ),
        Word(
            term: "virtualization",
            pronunciation: "/ˌvɜrtʃuəlɪˈzeɪʃən/",
            partOfSpeech: "noun",
            definition:
                "The act of creating a virtual (rather than actual) version of something, including virtual computer hardware platforms, storage devices, and computer network resources.",
            example:
                "Virtualization allows multiple operating systems to run on a single physical server.",
            category: .technology
        ),
        Word(
            term: "middleware",
            pronunciation: "/ˈmɪdəlˌwɛər/",
            partOfSpeech: "noun",
            definition:
                "Software that acts as a bridge between an operating system or database and applications, especially on a network.",
            example:
                "The middleware layer enables different software applications to communicate with each other.",
            category: .technology
        ),
    ]

    // Academic category words
    static let academicWords: [Word] = [
        Word(
            term: "paradigm",
            pronunciation: "/ˈpærəˌdaɪm/",
            partOfSpeech: "noun",
            definition: "A typical example or pattern of something; a model.",
            example: "The discovery resulted in a paradigm shift in scientific thinking.",
            category: .academic
        ),
        Word(
            term: "empirical",
            pronunciation: "/ɪmˈpɪrɪkəl/",
            partOfSpeech: "adjective",
            definition:
                "Based on, concerned with, or verifiable by observation or experience rather than theory or pure logic.",
            example: "The study provided empirical evidence to support the hypothesis.",
            category: .academic
        ),
        Word(
            term: "pedagogy",
            pronunciation: "/ˈpɛdəˌɡoʊdʒi/",
            partOfSpeech: "noun",
            definition:
                "The method and practice of teaching, especially as an academic subject or theoretical concept.",
            example: "The university offers courses in pedagogy for aspiring teachers.",
            category: .academic
        ),
        Word(
            term: "epistemology",
            pronunciation: "/ɪˌpɪstəˈmɒlədʒi/",
            partOfSpeech: "noun",
            definition:
                "The theory of knowledge, especially with regard to its methods, validity, and scope, and the distinction between justified belief and opinion.",
            example: "The philosophy course covered epistemology and the nature of knowledge.",
            category: .academic
        ),
        Word(
            term: "dissertation",
            pronunciation: "/ˌdɪsərˈteɪʃən/",
            partOfSpeech: "noun",
            definition:
                "A long essay on a particular subject, especially one written for a university degree or diploma.",
            example: "She spent a year researching and writing her doctoral dissertation.",
            category: .academic
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
            example: "Finding that rare book at a garage sale was pure serendipity.",
            category: .everyday
        ),
        Word(
            term: "ubiquitous",
            pronunciation: "/juːˈbɪkwɪtəs/",
            partOfSpeech: "adjective",
            definition: "Present, appearing, or found everywhere.",
            example: "Smartphones have become ubiquitous in modern society.",
            category: .everyday
        ),
        Word(
            term: "procrastinate",
            pronunciation: "/proʊˈkræstɪˌneɪt/",
            partOfSpeech: "verb",
            definition: "Delay or postpone action; put off doing something.",
            example: "He procrastinated until the deadline was imminent.",
            category: .everyday
        ),
        Word(
            term: "meticulous",
            pronunciation: "/məˈtɪkjələs/",
            partOfSpeech: "adjective",
            definition: "Showing great attention to detail; very careful and precise.",
            example: "She was meticulous in her preparation for the presentation.",
            category: .everyday
        ),
        Word(
            term: "resilience",
            pronunciation: "/rɪˈzɪliəns/",
            partOfSpeech: "noun",
            definition: "The capacity to recover quickly from difficulties; toughness.",
            example: "The community showed remarkable resilience in the aftermath of the disaster.",
            category: .everyday
        ),
    ]

    // Function to get words based on selected categories
    static func getWordsForCategories(_ categories: [WordCategory], count: Int = 5) -> [Word] {
        var selectedWords: [Word] = []

        // Add words from each selected category
        for category in categories {
            if let words = wordsByCategory[category] {
                selectedWords.append(contentsOf: words)
            }
        }

        // If no categories selected or no words found, use default words
        if selectedWords.isEmpty {
            selectedWords = [
                Word(
                    term: "logophile",
                    pronunciation: "/ˈlɒɡəfʌɪl/",
                    partOfSpeech: "noun",
                    definition: "A lover of words.",
                    example:
                        "As a logophile, Julia loved to read new books to discover words she hadn't heard before.",
                    category: .everyday
                ),
                Word(
                    term: "ephemeral",
                    pronunciation: "/ɪˈfɛm(ə)rəl/",
                    partOfSpeech: "adjective",
                    definition: "Lasting for a very short time.",
                    example:
                        "The ephemeral nature of fashion trends makes it hard to keep up with what's in style.",
                    category: .everyday
                ),
                Word(
                    term: "eloquent",
                    pronunciation: "/ˈɛləkwənt/",
                    partOfSpeech: "adjective",
                    definition: "Fluent or persuasive in speaking or writing.",
                    example: "Her eloquent speech moved the entire audience to tears.",
                    category: .everyday
                ),
                Word(
                    term: "verbose",
                    pronunciation: "/vɜrˈboʊs/",
                    partOfSpeech: "adjective",
                    definition: "Using or containing more words than are necessary.",
                    example: "The verbose report could have been summarized in a few paragraphs.",
                    category: .everyday
                ),
                Word(
                    term: "panacea",
                    pronunciation: "/ˌpænəˈsiə/",
                    partOfSpeech: "noun",
                    definition: "A solution or remedy for all difficulties or diseases.",
                    example:
                        "Exercise is not a panacea for all health problems, but it helps with many.",
                    category: .everyday
                ),
            ]
        }

        // Shuffle and limit to requested count
        selectedWords.shuffle()
        if selectedWords.count > count {
            selectedWords = Array(selectedWords.prefix(count))
        }

        // Ensure we have at least the requested number of words by duplicating if necessary
        while selectedWords.count < count {
            if let randomWord = selectedWords.randomElement() {
                let duplicatedWord = Word(
                    term: randomWord.term,
                    pronunciation: randomWord.pronunciation,
                    partOfSpeech: randomWord.partOfSpeech,
                    definition: randomWord.definition,
                    example: randomWord.example,
                    category: randomWord.category
                )
                selectedWords.append(duplicatedWord)
            }
        }

        return selectedWords
    }
}

// MARK: - Extended AppState for Category-Based Word Loading

extension AppState {
    func loadCategoryBasedWords() {
        // Get selected categories from user preferences
        let categories = userPreferences.selectedCategories

        // Load words based on categories
        words = CategoryWordSets.getWordsForCategories(categories)

        // Update any existing WordCardViewModel
        for viewModel in wordViewModels {
            viewModel.words = words
        }
    }
}
