import Foundation

extension Word {
    static let sampleWords: [Word] = [
        // Science words
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

        // Business words
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

        // Arts words
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
            example:
                "The city experienced a cultural renaissance after the new arts center opened.",
            category: .arts
        ),

        // Technology words
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

        // Academic words
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

        // Everyday words
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
    ]
}
