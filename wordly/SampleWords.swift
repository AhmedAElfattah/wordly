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
        Word(
            term: "hypothesis",
            pronunciation: "/haɪˈpɒθəsɪs/",
            partOfSpeech: "noun",
            definition:
                "A proposed explanation for a phenomenon, made on the basis of limited evidence as a starting point for further investigation.",
            example:
                "His hypothesis about the effect of pollution on marine life was supported by the data.",
            category: .science
        ),
        Word(
            term: "entropy",
            pronunciation: "/ˈɛntrəpi/",
            partOfSpeech: "noun",
            definition:
                "A thermodynamic quantity representing the unavailability of a system's thermal energy for conversion into mechanical work.",
            example:
                "According to the second law of thermodynamics, entropy in an isolated system never decreases.",
            category: .science
        ),
        Word(
            term: "mitochondria",
            pronunciation: "/ˌmaɪtəˈkɒndrɪə/",
            partOfSpeech: "noun",
            definition:
                "An organelle found in large numbers in most cells, in which the biochemical processes of respiration and energy production occur.",
            example: "Mitochondria are often called the powerhouses of the cell.",
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
        Word(
            term: "scalability",
            pronunciation: "/ˌskeɪləˈbɪləti/",
            partOfSpeech: "noun",
            definition:
                "The capacity to be changed in size or scale to meet increasing demands or growth.",
            example: "The startup's business model has excellent scalability.",
            category: .business
        ),
        Word(
            term: "leverage",
            pronunciation: "/ˈlevərɪdʒ/",
            partOfSpeech: "noun",
            definition:
                "The use of borrowed capital for an investment, expecting the profits to be greater than the interest payable.",
            example: "The company used leverage to finance its expansion into Asian markets.",
            category: .business
        ),
        Word(
            term: "synergy",
            pronunciation: "/ˈsɪnərji/",
            partOfSpeech: "noun",
            definition:
                "The interaction or cooperation of two or more organizations or agents to produce a combined effect greater than the sum of their separate effects.",
            example:
                "The merger created synergy between the marketing and distribution departments.",
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
        Word(
            term: "chiaroscuro",
            pronunciation: "/kiˌɑːrəˈskʊəroʊ/",
            partOfSpeech: "noun",
            definition:
                "The treatment of light and shade in drawing and painting or the effect of contrasted light and shadow.",
            example: "Rembrandt was a master of chiaroscuro techniques.",
            category: .arts
        ),
        Word(
            term: "motif",
            pronunciation: "/moʊˈtiːf/",
            partOfSpeech: "noun",
            definition:
                "A distinctive feature or dominant idea in an artistic or literary composition.",
            example: "The composer used a recurring motif throughout the symphony.",
            category: .arts
        ),
        Word(
            term: "composition",
            pronunciation: "/ˌkɑːmpəˈzɪʃən/",
            partOfSpeech: "noun",
            definition:
                "The arrangement or placement of visual elements in a work of art or photography.",
            example: "The artist's careful composition drew the eye to the center of the canvas.",
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
        Word(
            term: "cryptocurrency",
            pronunciation: "/ˌkrɪptoʊˈkʌrənsi/",
            partOfSpeech: "noun",
            definition:
                "A digital currency in which encryption techniques are used to regulate the generation of units of currency and verify the transfer of funds, operating independently of a central bank.",
            example: "Bitcoin was the first decentralized cryptocurrency.",
            category: .technology
        ),
        Word(
            term: "virtualization",
            pronunciation: "/ˌvɜːrtʃuəlaɪˈzeɪʃən/",
            partOfSpeech: "noun",
            definition:
                "The act of creating a virtual (rather than actual) version of something, including virtual computer hardware platforms, storage devices, and computer network resources.",
            example: "Server virtualization has revolutionized data center management.",
            category: .technology
        ),
        Word(
            term: "encryption",
            pronunciation: "/ɪnˈkrɪpʃən/",
            partOfSpeech: "noun",
            definition:
                "The process of converting information or data into a code, especially to prevent unauthorized access.",
            example: "Strong encryption is essential for secure online banking.",
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
        Word(
            term: "pedagogy",
            pronunciation: "/ˈpedəɡɒdʒi/",
            partOfSpeech: "noun",
            definition:
                "The method and practice of teaching, especially as an academic subject or theoretical concept.",
            example: "The university offers courses in pedagogy for future teachers.",
            category: .academic
        ),
        Word(
            term: "epistemology",
            pronunciation: "/ɪˌpɪstəˈmɒlədʒi/",
            partOfSpeech: "noun",
            definition:
                "The theory of knowledge, especially with regard to its methods, validity, and scope, and the distinction between justified belief and opinion.",
            example: "Epistemology is a central branch of philosophy.",
            category: .academic
        ),
        Word(
            term: "hermeneutics",
            pronunciation: "/ˌhɜːrməˈnjuːtɪks/",
            partOfSpeech: "noun",
            definition:
                "The theory and methodology of interpretation, especially of biblical texts, wisdom literature, and philosophical texts.",
            example: "The professor specializes in hermeneutics and textual analysis.",
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
        Word(
            term: "ephemeral",
            pronunciation: "/ɪˈfɛmərəl/",
            partOfSpeech: "adjective",
            definition: "Lasting for a very short time.",
            example: "The ephemeral nature of fashion trends means styles quickly become outdated.",
            category: .everyday
        ),
        Word(
            term: "cacophony",
            pronunciation: "/kəˈkɒfəni/",
            partOfSpeech: "noun",
            definition: "A harsh, discordant mixture of sounds.",
            example: "The cacophony of the construction site made it difficult to concentrate.",
            category: .everyday
        ),
        Word(
            term: "panacea",
            pronunciation: "/ˌpænəˈsiːə/",
            partOfSpeech: "noun",
            definition: "A solution or remedy for all difficulties or diseases.",
            example: "Exercise is not a panacea for all health problems, but it certainly helps.",
            category: .everyday
        ),
        Word(
            term: "eloquent",
            pronunciation: "/ˈɛləkwənt/",
            partOfSpeech: "adjective",
            definition: "Fluent or persuasive in speaking or writing.",
            example: "Her eloquent speech moved the entire audience.",
            category: .everyday
        ),
        Word(
            term: "meticulous",
            pronunciation: "/məˈtɪkjələs/",
            partOfSpeech: "adjective",
            definition: "Showing great attention to detail; very careful and precise.",
            example: "The watchmaker's meticulous craftsmanship was evident in every piece.",
            category: .everyday
        ),
        Word(
            term: "procrastinate",
            pronunciation: "/proʊˈkræstɪneɪt/",
            partOfSpeech: "verb",
            definition: "Delay or postpone action; put off doing something.",
            example: "I tend to procrastinate when faced with difficult tasks.",
            category: .everyday
        ),
        Word(
            term: "quintessential",
            pronunciation: "/ˌkwɪntɪˈsɛnʃəl/",
            partOfSpeech: "adjective",
            definition: "Representing the most perfect or typical example of a quality or class.",
            example: "The corner café is the quintessential Parisian experience.",
            category: .everyday
        ),
        Word(
            term: "ambivalent",
            pronunciation: "/æmˈbɪvələnt/",
            partOfSpeech: "adjective",
            definition: "Having mixed feelings or contradictory ideas about something or someone.",
            example: "She felt ambivalent about moving to a new city.",
            category: .everyday
        ),
    ]
}
