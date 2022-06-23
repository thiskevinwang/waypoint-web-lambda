import type { NextPage } from "next";
import Head from "next/head";
import Image from "next/image";
import styles from "../styles/Home.module.css";

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
      <Head>
        <title>Hello from Node + Next!</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>Waypoint</h1>

        <p className={styles.description}>
          Easy application deployment for Amazon Lambda, Kubernetes, Amazon ECS,
          and many more!
        </p>

        <div className={styles.grid}>
          <a href="https://waypointproject.io/docs" className={styles.card}>
            <h2>Documentation &rarr;</h2>
            <p>Find in-depth information about Waypoint features and API.</p>
          </a>

          <a
            href="https://learn.hashicorp.com/waypoint"
            className={styles.card}
          >
            <h2>Learn &rarr;</h2>
            <p>Learn about Waypoint through tutorials and videos!</p>
          </a>

          <a
            href="https://github.com/thiskevinwang/waypoint-web-lambda"
            className={styles.card}
          >
            <h2>Examples &rarr;</h2>
            <p>
              Discover and deploy boilerplate example Waypoint projects to AWS
              Lambda in various languages, including <code>deno</code>,{" "}
              <code>go</code>, <code>node</code>, <code>python</code>,{" "}
              <code>rust</code>, and <code>swift</code>.
            </p>
          </a>

          <a
            href="https://vercel.com/new?utm_source=create-next-app&utm_medium=default-template&utm_campaign=create-next-app"
            className={styles.card}
          >
            <h2>Deploy &rarr;</h2>
            <p>
              Instantly deploy your Next.js site to a public URL with Vercel.
            </p>
          </a>
        </div>
      </main>

      <footer className={styles.footer}>🤙</footer>
    </div>
  );
};

export default Home;
